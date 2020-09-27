#!/usr/bin/env bash
# Generate a GitHub "profile README" with a simple listing of all public repos and gists sorted alphabetically
# ascending.
#
# Requires a copy of the repo data and gists data. See the notes in 'lib.jq' for the relevant GitHub API documentation.

set -eu

# Clear it if it exists already
> README.md

# Format the Markdown snippets from the GitHub JSON data
repos=$(cat repos.json | jq -r 'include "lib"; format_md_repo_listing')
gists=$(cat gists.json | jq -r 'include "lib"; format_md_gist_listing')

# Stamp out the README.md file from the template file using 'awk'.
# Yay 'awk'! I learned some awk and found that it is an effective templating mechanism for simple use-cases like this.
# See my notes and example scripts at:
#  * https://github.com/dgroomes/bash-playground/blob/855405c3d6c1a3a820d6b3656e773249460ded19/misc/awk-examples.sh
#  * https://github.com/dgroomes/bash-playground/blob/855405c3d6c1a3a820d6b3656e773249460ded19/templating/template.sh
awk '
 BEGIN {
   repos=ARGV[2]; ARGV[2]="";
   gists=ARGV[3]; ARGV[3]="";
 }

 {
   gsub(/%REPOS%/, repos);
   gsub(/%GISTS%/, gists);
 }1
' README.template.md "$repos" "$gists" >> README.md

echo "README.md was generated. Its contents (abbreviated):"
head -n20 README.md
printf "\n...skipped...\n\n"
tail -n20 README.md

