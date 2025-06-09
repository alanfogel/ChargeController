# Pi Charge Controller Setup

This repository extends a Pi already running `dendro-pi-main` by adding support for logging and uploading solar charge controller data.

---

---

## 🔧 Initial Setup Instructions (On Raspberry Pi)

### 1. Clone This Repository

```bash
cd ~/dendro-pi-main  # Must already exist
git clone https://github.com/alanfogel/Pi_ChargeController.git
cd Pi_ChargeController
```

### 2. Run the Setup Script  
##### (This may take several minutes)
```bash
bash setup.sh
```

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
*/5 * * * * /home/madlab/charge_controller/venv/bin/renogymodbus --device charge_controller --portname /dev/ttyUSB0 --slaveaddress 17
````
