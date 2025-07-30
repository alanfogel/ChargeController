#!/bin/bash

# Define paths
LOG_DIR="/home/madlab/dendro-pi-main/ChargeController/logs"
DROPBOX_FOLDER="/Dorval-Solar_TEST/"
UPLOAD_LOG="/home/madlab/dendro-pi-main/ChargeController/logs/upload_output.txt"

# Get today’s date in format YYYY-MM-DD
TODAY=$(date +%F)

# Step 1: Find all log files except today’s and write them to a list
echo "Uploading all .csv files from $LOG_DIR except today's file ($TODAY)..."
find "$LOG_DIR" -name "charge_controller_*.csv" > "$LOG_DIR/logs_to_upload.txt"

# Step 2: Upload each file, one at a time, saving results to a file
# Clear old log file before starting
> "$UPLOAD_LOG"

while IFS= read -r FILE; do
  echo " > Uploading $FILE..."
  cd /home/madlab/dendro-pi-main/Dropbox-Uploader || exit 1
  ./dropbox_uploader.sh upload "$FILE" "$DROPBOX_FOLDER" | tee -a "$UPLOAD_LOG"
done < "$LOG_DIR/logs_to_upload.txt"

# Step 3: Parse the upload result to find files that already exist (same hash)
grep "file exists with the same hash" "$UPLOAD_LOG" > "$LOG_DIR/already_uploaded.txt"

# Step 4: Delete any files that were confirmed already on Dropbox (skip today's file)
while IFS= read -r line; do
  # Extract full path between quotes
  FULL_PATH=$(echo "$line" | cut -d'"' -f 2)
  BASENAME=$(basename "$FULL_PATH")

  if [[ "$BASENAME" != "charge_controller_${TODAY}.csv" && -f "$FULL_PATH" ]]; then
    echo "Deleting $FULL_PATH (confirmed on Dropbox)"
    rm -v "$FULL_PATH"
  else
    echo "Skipping $FULL_PATH (today's file or missing)"
  fi
done < "$LOG_DIR/already_uploaded.txt"

for file in already_uploaded.txt logs_to_upload.txt upload_output.txt; do
  if [ -f "$LOG_DIR/$file" ]; then
    rm "$LOG_DIR/$file"
    echo "Deleted $file"
  fi
done
