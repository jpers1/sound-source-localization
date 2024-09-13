#!/bin/bash

# Define the source directory where the new files are located
SOURCE_DIR="/home/eminaf/experiment_data/"

# Define the base destination directory
BASE_DEST_DIR="/home/eminaf/experiment_data/"

# Get the timestamp from the newly transferred files
TIMESTAMP=$(ls "$SOURCE_DIR" | grep -oE '[0-9]{14}' | sort | tail -n 1)

# Check if any files were found with a timestamp
if [ -z "$TIMESTAMP" ]; then
    echo "No new files with a timestamp found in $SOURCE_DIR"
    exit 1
fi

# Create a new directory with the timestamp
DEST_DIR="$BASE_DEST_DIR/$TIMESTAMP"
mkdir -p "$DEST_DIR"

# Create 8 new directories (mic_1 to mic_8) inside the new directory
for i in {0..8}; do
    MIC_DIR="$DEST_DIR/mic_$i"
    mkdir -p "$MIC_DIR/left_channel"
    mkdir -p "$MIC_DIR/right_channel"
done

# Move the new files to the new directory, excluding the directory itself
find "$SOURCE_DIR" -maxdepth 1 -type f -name "*$TIMESTAMP*" -exec mv {} "$DEST_DIR" \;

echo "$TIMESTAMP" # Output the destination directory
# Script completed

