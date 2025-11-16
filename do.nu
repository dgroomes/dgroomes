const DIR = path self | path dirname

export def --env setup [] {
    $env.GITHUB_PAT = input --suppress-output "GitHub PAT: "
}

export def refresh-repos [] {
    cd $DIR
    python3 refresh-github-data.py repos
}

export def refresh-gists [] {
    cd $DIR
    python3 refresh-github-data.py gists
}

export def generate-readme [] {
    cd $DIR
    ./generate-readme.sh
}
