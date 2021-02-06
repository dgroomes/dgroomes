# README-2

This is the real README file for this repo. The file literally named _README.md_ is reserved as my
[GitHub "profile README"](https://docs.github.com/en/free-pro-team@latest/github/setting-up-and-managing-your-github-profile/managing-your-profile-readme).

This repo has scripts to auto-generate a GitHub "profile README" from a template file (`README.template.md`) and GitHub
data. These scripts are general-purpose enough to copy and use for yourself. For personal use, feel free to use this
repo as a template for your own GitHub "profile README" by clicking the "Use this template" button in GitHub.

### Instructions

NOTE: I am using macOS to execute these scripts.

1. Download your GitHub repositories and gists data with:
    * `./refresh-github-data.sh repos`
    * `./refresh-github-data.sh gists`
1. Generate a `README.md` file from your now-downloaded GitHub data with:
    * `./generate-readme.sh`
1. Customize the `README.md` by hand to your taste! For example, add a note at the top about yourself. Or, delete
   certain repositories or gists that you don't want to highlight. 

The simple auto-generation script plus some hand-written customization is a good mix of automation and simplicity, in my 
opinion. I've found that continually using the "generate" script and then using a visual diff tool (like the one baked
into Intellij) let's me easily re-apply my customizations after the "generate" script overwrites them.

## Wish List

General clean-ups, TODOs and things I wish to implement for this project:

* DONE Download the `repos.json` and `gists.json` files from a script
* DONE Exclude "archived" repos from the "generate" script
* DONE Exclude forked repos
* DONE Add my GitHub gists to the README. Automate this process in the "generate" script.
* DONE Use a template file (`README.template.md`) to de-couple the data and scripting stuff from the hand-written
  content. After all, it's easy to glance at `README.template.md` and quickly get an idea for what this repo is all
  about!
* IN PROGRESS Generate GitHub Actions workflow status badges in the `generate-readme.sh` script. This will be practical only if the
  badge URLs can be automatically gleaned from information returned by the GitHub APIs. If the status badge URL must be
  manually written then that goes against the spirit of this tool, which is to automatically generate the vast majority
  of the GitHub personal README page content. Requires research. Read the [docs on workflow status badges](https://docs.github.com/en/actions/managing-workflow-runs/adding-a-workflow-status-badge).
