const DIR = path self | path dirname

export def --env setup [] {
    $env.GITHUB_PAT = input --suppress-output "GitHub PAT: "
}

export def refresh-repos [] {
    cd $DIR
    python3 refresh-github-data.py repos
}

export def refresh-gists [] {
    cd $DIR
    python3 refresh-github-data.py gists
}

# Generate a GitHub "profile README" with a listing of all public repos and gists sorted alphabetically
# ascending.
#
# Requires a copy of the repo data and gists data. See the notes in 'lib.jq' for the relevant GitHub API documentation.
#
export def generate-readme [] {
    cd $DIR

    # Format the Markdown snippets from the GitHub JSON data
    let repos_table = open repos.json | format_html_repo_listing_table
    let repos_list = open repos.json | format_md_repo_listing_list
    let gists = open gists.json | format_md_gist_listing

    # Stamp out the README.md file from the template.
    (open --raw README.template.md
      | str replace '%REPOS_TABLE%' $repos_table
      | str replace '%REPOS_LIST%' $repos_list
      | str replace '%GISTS%' $gists
      | save --force README.md)

    print "README.md was generated. Its contents (abbreviated):"
    head README.md
    print "\n...skipped..."

    tail README.md
}

# Format a Markdown link given a description and a URL
def format_md_link [desc: string, url: string]: nothing -> string {
    $"[($desc)]\(($url))"
}

# Get the first field in an object (returns the key name)
def first_field []: record -> string {
    $in | columns | first
}

# Split a list into chunks of a given size
def chunk [size: int]: list -> list {
    let items = $in
    if ($items | is-empty) {
        []
    } else {
        $items | enumerate | group-by {|item| $item.index // $size } | values | each {|group| $group | get item }
    }
}

# Format a Markdown listing of GitHub repos (sorted alphabetically, excludes archived and forked repos)
def format_md_repo_listing_list []: list -> string {
    $in
    | where archived == false
    | where fork == false
    | sort-by name
    | each {|repo|
        let link = (format_md_link $repo.name $repo.html_url)
        $"* ($link)\n  * > ($repo.description)"
      }
    | str join "\n"
}

# Generate an HTML table listing of GitHub repos (5 columns per row)
def format_html_repo_listing_table []: list -> string {
    $in
    | where archived == false
    | where fork == false
    | sort-by name
    | each {|repo|
        let short_name = ($repo.name | str replace --all '-playground' '')
        $"<td><a href='($repo.html_url)'>($short_name)</a></td>"
      }
    | chunk 5
    | each {|row| $"<tr>\n($row | str join "\n")</tr>" }
    | str join "\n"
}

# Format a Markdown listing of GitHub gists
def format_md_gist_listing []: list -> string {
    $in
    | each {|gist|
        let filename = ($gist.files | first_field)
        let file_data = ($gist.files | get $filename)
        let link = (format_md_link $"`($file_data.filename)`" $gist.html_url)
        $"* ($link)"
      }
    | str join "\n"
}
