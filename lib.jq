# jq (https://stedolan.github.io/jq/manual/) helper functions

# List the repository names
def list_repo_names:
  .[].name;


# Format a Markdown link given a description and a URL
# Remember, your handy dandy Markdown cheat sheet: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
def format_md_link($desc; $url):
    "[\($desc)](\($url))";


# Get the first field in an object
def first_field:
    keys[0] as $firstfield | .[$firstfield];


# Format a Markdown listing of GitHub repos
# The listing is sorted alphabetically, excludes archived repos, and excludes forked repos
def format_md_repo_listing_list:
    sort_by(.name)
    | .[]
    | select(.archived | not)
    | select(.fork | not)
    | format_md_link(.name; .html_url) as $link
    | "* \($link)\n  * > \(.description)";


# Utility function to create array chunks (sub-arrays of a given size)
def chunk($size):
    if length == 0 then
        []
    else
        [.[0:$size]], (.[ $size: ] | chunk($size))
    end;

# Generate an HTML table listing of GitHub repos
def format_html_repo_listing_table:
    sort_by(.name)
    | map(select(.archived | not))
    | map(select(.fork | not))
    | map(. + { short_name: .name | sub("-playground"; ""; "g") })

    # Create an HTML link and table cell for each repo
    | map("<td><a href='\(.html_url)'>\(.short_name)</a></td>")

    # Chunk into sections to create rows
    | chunk(5)

    # Create rows and wrap in table row tags
    | map(join("\n") | "<tr>\n" + . + "</tr>")
    | join("\n");


# Format a Markdown listing of GitHub gists.
def format_md_gist_listing:
    .[]
    | (.files | first_field | .filename) as $filename
    | format_md_link("`\($filename)`"; .html_url)
    | "* \(.)";
