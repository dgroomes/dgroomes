#!/usr/bin/env bash
#
# Refresh the GitHub repositories or gists data.
# This will only request up to 100 repos and gists because I have not implemented paging in the API request.

GITHUB_API_ORIGIN="https://api.github.com"
USER=dgroomes

# 'List repositories for a user' API URL path pattern. https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#list-repositories-for-a-user
REPOS_URL_PATTERN="%s/users/%s/repos?per_page=100"
# 'List gists for a user' API URL path pattern. https://docs.github.com/en/free-pro-team@latest/rest/reference/gists#list-gists-for-a-user
GISTS_URL_PATTERN="%s/users/%s/gists?per_page=100"

usage() {
  echo >&2 "Usage: $0 <repos | gists>"
  exit 1
}

if [[ "x$1" = "x" ]]; then
  usage
fi

set -eu

if [[ $1 == "repos" ]]; then
  url=$(printf $REPOS_URL_PATTERN $GITHUB_API_ORIGIN $USER)
  data_file=repos.json
elif [[ $1 == "gists" ]]; then
  url=$(printf $GISTS_URL_PATTERN $GITHUB_API_ORIGIN $USER)
  data_file=gists.json
else
  usage
fi

curl --request GET \
  --url "$url" \
  --header 'accept: application/vnd.github.v3+json' \
  --header 'content-type: application/json' > "$data_file"

echo "Data downloaded to '$data_file'"
