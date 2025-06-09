
---

## 🖥️ **New `setup.sh` Script**
```bash
#!/bin/bash

set -e

echo "🔧 Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate

echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

echo "📂 Overwriting patched command_line.py..."
cp command_line.py venv/lib/python3.11/site-packages/renogymodbus/command_line.py

echo "📤 Installing Dropbox upload script..."
mkdir -p /home/madlab/dendro-pi-main/
cp upload-to-dropbox_SOLAR.sh /home/madlab/dendro-pi-main/upload-to-dropbox.sh
chmod +x /home/madlab/dendro-pi-main/upload-to-dropbox.sh

echo "🕓 Installing crontab..."
crontab my_crontab_backup.txt

echo "✅ Setup complete!"
