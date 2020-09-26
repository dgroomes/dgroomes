# jq (https://stedolan.github.io/jq/manual/) helper functions

def generate_html_description:
    sort_by(.name) | .[] | {html_url, description} | "* <\(.html_url)>\n  * > \(.description)";
