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
# 'List repository workflows' API URL path pattern. https://docs.github.com/en/rest/reference/actions#workflows
ACTIONS_WORKFLOWS_URL_PATTERN="%s/repos/%s/%s/actions/workflows"

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

  # WIP
  #
  # Download the GitHub Actions "workflows" data, repo by repo.
  #
  # List each repository name on a new line so that we can easily iterate over the list in the script and curl the GitHub
  # API to get GitHub Actions "Workflow" data for each repo.
  #
  # Editorialization: A side effect of implementing a program with a combination of jq and another programming language (in this case Bash)
  # is that the message passing is difficult. Passing data *to* jq is easy: we just send our data (JSON formatted already
  # because that's what APIs use!) into standard input and jq can do its thing. By contrast, extracting data *from* jq for
  # use in Bash is hard. Bash doesn't understand JSON and so we have to use techniques like formatting the data in tab-separated
  # tuples and having each tuple on a new line. Then, in the Bash script we can iterate over the the lines naturally and
  # use a command like "cut" to access the specific tab-separated columns. jq is nice because it's an expressive functional
  # language but it can't do things like make HTTP requests and so we have to pair a jq program with another programming
  # language and resort to tricks like creating intermediate "message passing" files to get data out of jq and into Bash.
  REPO_NAMES="$TEMP_DIR/_temp-repo-names.txt"
  cat "$DOWNLOAD_FILE" | jq -r 'include "lib"; list_repo_names' > "$REPO_NAMES"

  WORKFLOWS="_temp-workflows.txt"
  while read -r repo_name; do
    echo "repo_name: $repo_name"
    URL=$(printf "$ACTIONS_WORKFLOWS_URL_PATTERN" "$GITHUB_API_ORIGIN" "$USER" "$repo_name")
    DOWNLOAD_FILE="$TEMP_DIR/_temp-workflow-$repo_name.json"
    download

    # Splice in the repo name to the JSON to make life easier for the 'generate-readme.sh' script.
    tmp="$TEMP_DIR/temp.json"
    > "$tmp"
    cat "$DOWNLOAD_FILE" | jq --arg repo_name "$repo_name" '. + { $repo_name }' > "$tmp"
    mv "$tmp" "$DOWNLOAD_FILE"
  done < "$REPO_NAMES"

else
  usage
fi
