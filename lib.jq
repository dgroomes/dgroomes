# jq (https://stedolan.github.io/jq/manual/) helper functions

# Format an HTML listing of GitHub repos
# The input data is the JSON returned from the GitHub API endpoint for a user's repos: https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#list-repositories-for-a-user
def format_html_repo_listing:
    sort_by(.name) | .[] | {html_url, description} | "* <\(.html_url)>\n  * > \(.description)";

# Get the first field in an object
def first_field:
    keys[0] as $firstfield | .[$firstfield];

# Format an HTML listing of GitHub gists.
# The input data is the JSON returned from the GitHub API endpoint for a user's gists: https://docs.github.com/en/free-pro-team@latest/rest/reference/gists#list-gists-for-a-user
def format_html_gist_listing:
    .[]
    | (.files | first_field | .filename) as $filename
    | "* [`\($filename)`](\(.html_url))";
