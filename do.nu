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
    let repos_table = open --raw repos.json | jq -r 'include "lib"; format_html_repo_listing_table'
    let repos_list = open --raw repos.json | jq -r 'include "lib"; format_md_repo_listing_list'
    let gists = open --raw gists.json | jq -r 'include "lib"; format_md_gist_listing'

    # Stamp out the README.md file from the template.
    (open --raw README.template.md
      | str replace '%REPOS_TABLE%' $repos_table
      | str replace '%REPOS_LIST%' $repos_list
      | str replace '%GISTS%' $gists
      | save --force README.md)

    echo "README.md was generated. Its contents (abbreviated):"
    head README.md
    print "\n...skipped..."

    tail README.md
}
