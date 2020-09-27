# jq (https://stedolan.github.io/jq/manual/) helper functions

# Format a Markdown listing of GitHub repos
# The input data is the JSON returned from the GitHub API endpoint for a user's repos: https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#list-repositories-for-a-user
# The listing is sorted alphabetically and excludes Archived repos
def format_md_repo_listing:
    sort_by(.name)
    | .[]
    | select(.archived | not)
    | {html_url, description}
    | "* <\(.html_url)>\n  * > \(.description)";

# Get the first field in an object
def first_field:
    keys[0] as $firstfield | .[$firstfield];

# Format a Markdown link given a description and a URL
# Remember, your handy dandy Markdown cheat sheet: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
def format_md_link($desc; $url):
    "[\($desc)](\($url))";

# Format a Markdown listing of GitHub gists.
# The input data is the JSON returned from the GitHub API endpoint for a user's gists: https://docs.github.com/en/free-pro-team@latest/rest/reference/gists#list-gists-for-a-user
def format_md_gist_listing:
    .[]
    | (.files | first_field | .filename) as $filename
    | format_md_link("`\($filename)`"; "\(.html_url)")
    | "* \(.)";
