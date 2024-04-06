#!/usr/bin/env bash
#
# Refresh the GitHub repositories or gists data.
# This will only request up to 100 repos and gists because I have not implemented paging in the API request.

GITHUB_API_ORIGIN="https://api.github.com"
USER=dgroomes
PER_PAGE=100
TEMP_DIR=tmp

# 'List repositories for a user' API URL path pattern. https://docs.github.com/en/rest/reference/repos#list-repositories-for-a-user
REPOS_URL_PATTERN="%s/users/%s/repos?per_page=$PER_PAGE"
# 'List gists for a user' API URL path pattern. https://docs.github.com/en/rest/reference/gists#list-gists-for-a-user
GISTS_URL_PATTERN="%s/users/%s/gists?per_page=$PER_PAGE"

usage() {
  echo >&2 "Usage: $0 <repos | gists>"
  exit 1
}

if [[ "x$1" == "x" ]]; then
  usage
elif [[ "x$GITHUB_ACCESS_TOKEN" == "x" ]]; then
  echo >&2 "Expected GITHUB_ACCESS_TOKEN to be set but was not"
  exit 1
fi
DATA_TYPE="$1"

set -eu

mkdir -p "$TEMP_DIR"

# Make a GET request to the GitHub API to download data (e.g. repos, gists)
download() {
  curl --request GET --silent --show-error \
  --URL "$URL" \
  --header 'accept: application/vnd.github.v3+json' \
  --user "$USER:$GITHUB_ACCESS_TOKEN" \
  --header 'content-type: application/json' > "$DOWNLOAD_FILE"

  echo "Data downloaded to '$DOWNLOAD_FILE'"
}

if [[ "$DATA_TYPE" == "gists" ]]; then
  URL=$(printf $GISTS_URL_PATTERN $GITHUB_API_ORIGIN $USER)
  DOWNLOAD_FILE="gists.json"
  download
  exit 0
elif [[ "$DATA_TYPE" == "repos" ]]; then
  URL=$(printf $REPOS_URL_PATTERN $GITHUB_API_ORIGIN $USER)
  DOWNLOAD_FILE="repos.json"
  download
else
  usage
fi
