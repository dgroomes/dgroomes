# README-2

This is the real README file for this repo. The file literally named _README.md_ is reserved as my
[GitHub "profile README"](https://docs.github.com/en/free-pro-team@latest/github/setting-up-and-managing-your-github-profile/managing-your-profile-readme).

This repo has scripts to auto-generate a GitHub "profile README" from a template file (`README.template.md`) and GitHub
data. These scripts are general-purpose enough to copy and use for yourself.


## Instructions

Follow these instructions to download the data for your GitHub repositories and gists, and then generate a `README.md`.

1. Pre-requisites: Python 3, `jq`, `awk`, and Nushell
    * Also, I'm using macOS to execute these scripts.
2. Activate the `do.nu` script:
    * ```nushell
      do activate
      ```
3. Run the setup (set GitHub personal access token)
    * ```nushell
      do setup
      ```
4. Download your GitHub repositories and gists data with:
    * ```nushell
      do refresh-repos
      ```
    * ```nushell
      do refresh-gists
      ```
5. Generate a `README.md` file from your now-downloaded GitHub data with:
    * ```nushell
      do generate-readme
      ```
6. Customize the `README.md` by hand to your taste! For example, add a note at the top about yourself. Or, delete
   certain repositories or gists that you don't want to highlight. 

The simple auto-generation script plus some handwritten customization is a good mix of automation and simplicity, in my 
opinion. I've found that continually using the "generate" script and then using a visual diff tool (like the one baked
into Intellij) lets me easily re-apply my customizations after the "generate" script overwrites them. UPDATE 2025-11-16
I no longer do any handwritten customization, and I can't remember what that customization was. But I stand by the principle.


## Wish List

General clean-ups, TODOs and things I wish to implement for this project:

* [x] DONE Download the `repos.json` and `gists.json` files from a script
* [x] DONE Exclude "archived" repos from the "generate" script
* [x] DONE Exclude forked repos
* [x] DONE Add my GitHub gists to the README. Automate this process in the "generate" script.
* [x] DONE Use a template file (`README.template.md`) to de-couple the data and scripting stuff from the handwritten
  content. After all, it's easy to glance at `README.template.md` and quickly get an idea for what this repo is all
  about!
* [x] DONE Generate GitHub Actions workflow status badges in the `generate-readme.sh` script. This will be practical only if the
  badge URLs can be automatically gleaned from information returned by the GitHub APIs. If the status badge URL must be
  manually written then that goes against the spirit of this tool, which is to automatically generate the vast majority
  of the GitHub personal README page content. Requires research. Read the [docs on workflow status badges](https://docs.github.com/en/actions/managing-workflow-runs/adding-a-workflow-status-badge).
* [x] DONE Implement pagination so I can get above 100 repos.
* [x] DONE Rewrite the Bash script into Python (or any non-string language) because now I need to do pagination and things
  are silly.
* [x] DONE Drop the GitHub actions stuff. Way too gnarly (which I knew at the time and that was the reward of making
  something work and documenting the costs). If I bring it back it will be done in the main script (like Python)
  instead of parsing/passing/temp-directory-ing between Bash, files and jq.
* [ ] Re-implement `generate-readme.sh` in Python. Note that I don't really need to re-implement the jq stuff necessarily
  as long as I'm using it in a small functional way. But as soon as you get into message passing it's not worth it.
* [x] DONE Nushell. This is my shell now I don't want to bother with POSIX-like instructions like ` export GITHUB_PAT=your_token_here`
  which isn't valid nu syntax. No need to rewrite the core scripts but I need an entrypoint (`do.nu`). Although I want to rewrite it.
* [ ] Rewrite `generate-readme.sh` in nu
* [ ] Rewrite `lib.jq` in nu
* [ ] Consider rewrite into JSX. We should be able to get super simple static site generation with React thanks to server
  components (somewhat of a misnomer). I just want to see and learn how to do it.


## Reference

* [jq docs](https://stedolan.github.io/jq/manual/)
