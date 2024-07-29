#!/bin/bash

# Define the directory and output file
# DIR=~/media/photos/2023
DIR=/mnt/icybox2/media/photos/2023
OUTPUT="preview.jpg"
TEMP_DIR=$(mktemp -d)

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
find . -maxdepth 1 -type d -name "2023_*" | parallel process_folder {} $TEMP_DIR

# Use montage to combine all the preview images into a grid-like layout (3 images per row as an example)
montage "$TEMP_DIR/*_preview.png" -geometry +10+10 -tile 3x "$OUTPUT"

# Clean up temporary directory
rm -r "$TEMP_DIR"

echo "Preview created as $OUTPUT"

