#!/usr/bin/env bash
# Generate a GitHub profile-level README.md with a simple listing of all public repos and gists sorted alphabetically
# ascending.
#
# Requires a copy of the repo data and gists data. See the notes in 'lib.jq' for the relevant GitHub API documentation.

set -eu

README=README.md

# Clear it if it exists already
> "$README"

cat << EOF >> "$README"
### Hello! 👋

This is my [GitHub profile README](https://docs.github.com/en/free-pro-team@latest/github/setting-up-and-managing-your-github-profile/managing-your-profile-readme).
It is mostly generated from a simple Bash script. See <https://github.com/dgroomes/dgroomes/blob/main/README-2.md> for more.

### My Repositories <https://github.com/dgroomes?tab=repositories>

EOF

cat repos.json | jq -r 'include "lib"; format_md_repo_listing' >> "$README"

cat << EOF >> "$README"

### My Gists <https://gist.github.com/dgroomes>

EOF

cat gists.json | jq -r 'include "lib"; format_md_gist_listing' >> "$README"

echo "README.md was generated at '$README'. Its contents (abbreviated):"
head -n20 "$README"
printf "\n...skipped...\n\n"
tail -n20 "$README"

