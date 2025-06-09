#!/bin/bash
set -e

echo "Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate
echo "Installing required packages..."
pip install -r requirements.txt
deactivate

echo "Patching renogymodbus..."
cp command_line.py venv/lib/python3.*/site-packages/renogymodbus/command_line.py

echo "Installing crontab..."
crontab -l 2>/dev/null > current_cron || true
cat crontab_fragment.txt >> current_cron
crontab current_cron
rm current_cron

echo "Setup complete!"
