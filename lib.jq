# jq (https://stedolan.github.io/jq/manual/) helper functions

# List the repository names
def list_repo_names:
  .[].name;


# Format a Markdown link given a description and a URL
# Remember, your handy dandy Markdown cheat sheet: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
def format_md_link($desc; $url):
    "[\($desc)](\($url))";


# Get the first field in an object
def first_field:
    keys[0] as $firstfield | .[$firstfield];


# Build a map from the array of GitHub Actions worfklows. The map is keyed by repo name.
# Assumes that the workflows are passed via a global "$workflows" variable.
def workflows_to_map:
  $workflows
  | map({ key: .repo_name, value: .workflows })
  | from_entries;


# Construct the Markdown fragment for each GitHub Actions workflow "badge".
# If there are no workflows, return an empty string.
def format_md_badges(workflows):
  if workflows | length == 0
  then ""
  else workflows | .[] | " ![\(.name)](\(.badge_url))"
  end;


# Format a Markdown listing of GitHub repos
# The listing is sorted alphabetically, excludes archived repos, and excludes forked repos
def format_md_repo_listing_list:
    workflows_to_map as $workflows_map
    | sort_by(.name)
    | map(. + { workflows: $workflows_map[.name] })
    | .[]
    | select(.archived | not)
    | select(.fork | not)
    | format_md_link(.name; .html_url) as $link
    | format_md_badges(.workflows) as $badges
    | "* \($link)\($badges)\n  * > \(.description)";


# Utility function to create array chunks (sub-arrays of a given size)
def chunk($size):
    if length == 0 then
        []
    else
        [.[0:$size]], (.[ $size: ] | chunk($size))
    end;

# Format a Markdown listing of GitHub repos but in a table format.
def format_md_repo_listing_table:
    workflows_to_map as $workflows_map
    | sort_by(.name)
    | map(select(.archived | not))
    | map(select(.fork | not))
    | map([format_md_link(.name | sub("-playground"; ""; "g") | .[:24]; .html_url)])
    # Flatten the array to get a simple array of Markdown links
    | add
    # Chunk the array into sub-arrays of size 5 to create rows for the Markdown table
    | chunk(5)
    # Convert each chunk into a Markdown table row
    | map(join(" | "))
    # Join all the rows into a single Markdown table
    | join("\n");


# Format a Markdown listing of GitHub gists.
def format_md_gist_listing:
    .[]
    | (.files | first_field | .filename) as $filename
    | format_md_link("`\($filename)`"; .html_url)
    | "* \(.)";
