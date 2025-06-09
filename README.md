# Pi Charge Controller Setup

This repository extends a Pi already running `dendro-pi-main` by adding support for logging and uploading solar charge controller data.

---
## Prerequisites
- Make sure you have followed the initial setup instructions from: https://github.com/alanfogel/dendro-pi-main
---

## 🔧 Initial Setup Instructions (On Raspberry Pi)

### 1. Clone This Repository

```bash
cd ~/dendro-pi-main  # Must already exist
git clone https://github.com/alanfogel/ChargeController.git
cd ChargeController
```

### 2. Run the Setup Script  
##### (This may take several minutes)
```bash
bash setup.sh
```

### 3. Update the dropbox folder name in `upload-to-dropbox_SOLAR.sh`
```bash
nano upload-to-dropbox_SOLAR.sh
```
- Change line 15: ```DROPBOX_FOLDER="/Dorval-Solar_TEST```
to your desired folder name, e.g., `DROPBOX_FOLDER="/Dorval-Solar"`.

### Manual Steps (if setup script fails)
1. Install the required Python packages:
```bash
pip install -r requirements.txt
```

2. Update renogymodbus manually (if not automated):
```bash
cp command_line.py venv/lib/python3.11/site-packages/renogymodbus/command_line.py
```

3. Install Crontab Jobs
```bash
crontab -e
```
- Add the following lines to the crontab file:
```bash
# Upload Charge Controller Data every day (3am)
3 0 * * * sh /home/madlab/dendro-pi-main/upload-to-dropbox.sh

# Take Solar Charge Controller measurements every 5 minutes
*/5 * * * * /home/madlab/charge_controller/venv/bin/renogymodbus --device charge_controller --portname /dev/ttyUSB0 --slaveaddress 1
```

## Troubleshooting
1. ```minimalmodbus.NoResponseError: No communication with the instrument (no answer)```
   - The ```slaveaddress #``` argument in crontab may be in correct. The default is 1, but it may be different for your setup. A previous setup I had used the address 17.
