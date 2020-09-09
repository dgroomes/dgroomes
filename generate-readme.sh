#!/usr/bin/env bash
# Generate a GitHub profile-level README.md with a simple listing of all public repos sorted alphabetically ascending.
#
# Requires a copy of the repo data in the format given by the '/users/{username}/repos' endpoint. See the GitHub REST
# API docs at https://docs.github.com/en/rest/reference/repos#list-repositories-for-a-user

set -eu

README=README.md

# Clear it if it exists already
> "$README"

# Add the header
cat << EOF >> "$README"
### Hello! 👋

EOF

# Format the repo data and add it
cat repos.json \
    | jq -r '. | sort_by(.name) | .[] | {html_url, description} | "* <\(.html_url)>\n  * > \(.description)"' \
    >> "$README"

echo "README.md was generated at '$README'. Its contents (abbreviated):"
head -n20 "$README"
