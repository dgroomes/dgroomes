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

<https://github.com/dgroomes>

### Repositories

EOF

cat repos.json | jq -r 'include "lib"; format_html_repo_listing' >> "$README"

cat << EOF >> "$README"

### Gists <https://gist.github.com/dgroomes>

EOF

cat gists.json | jq -r 'include "lib"; format_html_gist_listing' >> "$README"

echo "README.md was generated at '$README'. Its contents (abbreviated):"
head -n20 "$README"
printf "\n...skipped...\n\n"
tail -n20 "$README"

