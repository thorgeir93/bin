#!/bin/sh
# VERSION BUMPER - for Python Projects
#
# DESCRIPTION:
#   User interactive interface for bumping the version of all
#   python projects in the current directory. The script will
#   find all projects with a pyproject.toml file and check if
#   there are any changes to the current branch. If there are
#   changes, the script will print out the changes and ask if
#   you want to bump the version of the project. If you choose
#   to bump the version, the script will run the command
#   `poetry version <major|minor|patch>` depending on your choice.
#
# USAGE:
#   $ ./version_bumper.sh
#
# POETRY MODE (explain)
#   x) poetry version major
#      - Bump the major version of the project
#   y) poetry version minor
#      - Bump the minor version of the project
#   z) poetry version patch
#      - Bump the patch version of the project
#   i) git diff origin/development -- .
#      - Show the full changes to the current branch
#   s) git diff --stat origin/development -- .
#      - Show minimal UI of the changes to the current branch
#   s or hit enter) [ SKIP ]
#
#

lbreak() {
    echo "====";
}

mode_poetry_version() {
    prefix="(POETRY MODE)"
    while true; do
        echo "$prefix x) poetry version major (X.y.z)"
        echo "$prefix y) poetry version minor (x.Y.z)"
        echo "$prefix z) poetry version patch (x.y.Z)"
        echo "$prefix i) git diff origin/development -- . (Full change view)"
        echo "$prefix s) git diff --stat origin/development -- . (Summary change view)"
        echo "$prefix s or hit enter) No changes, go to next"
        echo "$prefix e) Exit"
        read -p "" xyzisne
        case $xyzisne in
            [Xx]* ) lbreak; poetry version major && break; lbreak; ;;
            [Yy]* ) lbreak; poetry version minor && break; lbreak; ;;
            [Zz]* ) lbreak; poetry version patch && break; lbreak; ;;
            [Ii]* ) lbreak; git diff origin/development -- .; lbreak; ;;
            [Ss]* ) lbreak; git diff --stat origin/development -- .; lbreak; ;;
            [Nn]* ) lbreak; echo "NEXT"; lbreak; break; ;;
            [Ee]* ) echo exit && exit;;
            * ) lbreak; echo "NEXT"; lbreak; break; ;;
        esac
    done
}

check_diff() {
    local directory=$1
    if git diff --quiet origin/development -- . ':(exclude)poetry.lock'; then
        # No changes found in the current directory
        return
    else
        echo ">>>> $directory <<<<"
        git diff --stat origin/development -- .
        # TODO:2024-01-12:THS: Check for poetry version, if if already been change in the current branch.
        mode_poetry_version
        echo "Exiting $directory ..."
    fi
}

show_total_diff () {
    echo "========================================"
    echo "           TOTAL DIFF REPORT            "
    echo "========================================"
    echo "Comparing local changes against origin/development"
    echo ""
    git diff --stat origin/development
    echo ""
    echo "========================================"
    echo "           END OF REPORT                "
    echo "========================================"
}

main() {
  show_total_diff

  # Find directories with pyproject.toml
  for filename in $(find . -name 'pyproject.toml' ! -path './pyproject.toml'); do
      directory=$(dirname "$filename")
      pushd "$directory" > /dev/null
      check_diff "$directory"
      popd > /dev/null
  done
}

main
