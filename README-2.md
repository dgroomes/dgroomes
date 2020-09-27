# README-2

This is the real README file for this repo. The file literally named _README.md_ is reserved as my
["GitHub profile" README](https://docs.github.com/en/free-pro-team@latest/github/setting-up-and-managing-your-github-profile/managing-your-profile-readme).

### Instructions

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

## WishList

General clean-ups, TODOs and things I wish to implement for this project:

* DONE Download the `repos.json` and `gists.json` files from a script
* DONE Exclude "archived" repos from the "generate" script
* DONE Add my GitHub gists to the README. Automate this process in the "generate" script.
