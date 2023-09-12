#!/bin/bash

function usage() {
    echo "Usage: $0 <source_directory> <destination_directory>"
    echo
    echo "Compares files in source_directory with those in destination_directory."
    echo "Outputs any files that are present in the source but missing from the destination."
    echo
    echo "Example:"
    echo "  $0 /path/to/source/ /path/to/destination/"
    exit 1
}

# Display usage if -h or --help is provided as an argument
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# Check for the required number of arguments
if [ "$#" -ne 2 ]; then
    usage
fi

# Assign arguments to variables for clarity
SOURCE_DIR="$1"
DEST_DIR="$2"

# Generate file lists
# sed: Adjust the paths in source_files.txt to match the structure of destination_files.txt
tree -if --noreport "$SOURCE_DIR" | sed "s|^$SOURCE_DIR|$DEST_DIR|g" | sort > /tmp/source_files.txt
tree -if --noreport "$DEST_DIR" | sort > /tmp/destination_files.txt

# Use 'comm' to find lines only in source_files.txt (i.e., missing in destination)
comm -23 /tmp/source_files.txt /tmp/destination_files.txt | while IFS= read -r file; do
    echo "$file in $SOURCE_DIR but not in $DEST_DIR"
done

# Cleanup
rm /tmp/source_files.txt /tmp/destination_files.txt
