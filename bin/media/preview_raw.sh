#!/bin/bash

echo "*OUTDATED* PLEASE USE GITHUB REPO photos_viewer"
exit 1

# Check if at least 2 arguments are provided
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <DIRECTORY> <YEAR>"
  exit 1
fi

# Define the year and directory
YEAR=${2}
DIR="${1}/${YEAR}"
OUTPUT="preview.jpg"
TEMP_DIR=$(mktemp -d)

# Display the values for debugging
echo "Year: $YEAR"
echo "Directory: $DIR"
echo "Output file: $OUTPUT"
echo "Temporary directory: $TEMP_DIR"

# Config how to clean up the temporary directory
# Trap removes the temp dir even when the script fails.
trap "rm -rf $TEMP_DIR" EXIT

#DIR=/media/sda2/media/photos/${YEAR}

process_folder() {
    folder=$1
    TEMP_DIR=$2

    # Find the first ARW or CR2 file
    image=$(ls "$folder"/*.{ARW,CR2} 2>/dev/null | head -1)
    if [ -n "$image" ]; then
        # Use half-size decoding with dcraw and pipe the result directly to convert for labeling and resizing
        dcraw -c -h -q 3 -w -b 1 "$image" | \
        convert - -background '#0008' -fill white -gravity center -size 800x120 \
        label:"${folder##*/}" - +swap -gravity north -composite \
        "$TEMP_DIR/${folder##*/}_preview.png"
    fi
}

export -f process_folder

# Navigate to the directory
cd $DIR

# Process each subdirectory in parallel
find . -maxdepth 1 -type d -name "${YEAR}_*" | parallel process_folder {} $TEMP_DIR

# Use montage to combine all the preview images into a grid-like layout (3 images per row as an example)
montage "$TEMP_DIR/*_preview.png" -geometry +10+10 -tile 3x "$OUTPUT"


echo "Preview created as $OUTPUT"
