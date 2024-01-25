# My bin

Custom made and copied script from the web to make my life easier.


# Make repo accessable in homedir

Make sure that there aren't already `~/bin` folder.

```sh
# Navigate to the repo root
cd /home/thorgeir/git/hub/thorgeir/bin

# create symbolic link on in the homedir, to make it easy accessable.
ln -s $(pwd)/bin ~/
```


## bin/<script> usage

### `dir_comparison.sh`
Ultra fast directory camparison.

```sh
Usage: bin/dir_comparison.sh <source_directory> <destination_directory>

Compares files in source_directory with those in destination_directory.
Outputs any files that are present in the source but missing from the destination.

Example:
  bin/dir_comparison.sh /path/to/source/ /path/to/destination/
```


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

