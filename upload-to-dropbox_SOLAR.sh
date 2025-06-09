#!/bin/bash
# cd /home/madlab/dendro-pi-main/Dropbox-Uploader
# ./dropbox_uploader.sh upload ~/dendro-pi-main/pictures/* /Dorval-2/ | grep "file exists with the same hash" > already_uploaded.txt

# while IFS= read -r line; do
#   FILENAME=$(echo "$line" | cut -d'"' -f 2)
#   rm $FILENAME
# done < already_uploaded.txt

# Go to the directory where your log files are saved
cd /home/madlab/dendro-pi-main/Pi_ChargeController

# Get today’s date in format YYYY-MM-DD
TODAY=$(date +%F)
DROPBOX_FOLDER="/Dorval-Solar_TEST"

# Step 1: Find all log files except today’s and write them to a list
echo "Uploading all .csv files from /home/madlab/dendro-pi-main/Pi_ChargeController except today's file ($TODAY)..."
find /home/madlab/dendro-pi-main/Pi_ChargeController -name "charge_controller_*.csv" ! -name "charge_controller_${TODAY}.csv" > logs_to_upload.txt

# Step 2: Upload each file, one at a time, saving results to a file
UPLOAD_LOG="/home/madlab/dendro-pi-main/Pi_ChargeController/upload_output.txt"

# Clear old log file before starting
> "$UPLOAD_LOG"

while IFS= read -r FILE; do
  echo " > Uploading $FILE..."
  cd /home/madlab/Dropbox-Uploader || exit 1
  ./dropbox_uploader.sh upload "$FILE" "/Dorval-Solar_TEST/" | tee -a "$UPLOAD_LOG"
done < /home/madlab/dendro-pi-main/Pi_ChargeController/logs_to_upload.txt

# Step 3: Parse the upload result to find files that already exist (same hash)
grep "file exists with the same hash" /home/madlab/dendro-pi-main/Pi_ChargeController/upload_output.txt > /home/madlab/dendro-pi-main/Pi_ChargeController/already_uploaded.txt

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
done < /home/madlab/dendro-pi-main/Pi_ChargeController/already_uploaded.txt

for file in already_uploaded.txt logs_to_upload.txt upload_output.txt; do
  if [ -f "/home/madlab/dendro-pi-main/Pi_ChargeController/$file" ]; then
    rm "/home/madlab/dendro-pi-main/Pi_ChargeController/$file"
    echo "Deleted $file"
  fi
done