# My bin

Custom made and copied script from the web to make my life easier.


# Make repo accessable in homedir

```sh
# Navigate to the repo root
cd /home/thorgeir/git/hub/thorgeir/bin

# create symbolic link on in the homedir, to make it easy accessable.
ln -s $(pwd)/bin ~/bin
```


## bin/<script> usage

### `git_status_check.sh`

`git_status_check --help`
```sh
Usage: check_git_changes.sh [path_to_start_directory]

Recursively checks for Git repositories with changes.
If no directory is provided, current directory is used.

Examples:
  ./check_git_changes.sh
  ./check_git_changes.sh /path/to/start
```

