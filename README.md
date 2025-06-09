# Pi Charge Controller Setup

This repository contains scripts and instructions to set up a Raspberry Pi to monitor a solar charge controller and upload data to Dropbox daily.

---

## 🔧 Initial Setup Instructions (On Raspberry Pi)

### 1. Clone This Repository

```bash
git clone https://github.com/alanfogel/Pi_ChargeController.git
cd Pi_ChargeController
```

### 2. Run the Setup Script

```bash
chmod +x setup.sh
./setup.sh
```

### 3. Manual Steps (if needed)
Update renogymodbus manually (if not automated):
```bash
cp command_line.py venv/lib/python3.11/site-packages/renogymodbus/command_line.py
```


### 4. Installed Crontab Jobs
```bash
crontab -e
```
#### Add the following lines to the crontab file:
```bash
# Upload Charge Controller Data every day (3am)
3 0 * * * sh /home/madlab/dendro-pi-main/upload-to-dropbox.sh

# Take Solar Charge Controller measurements every 5 minutes
*/5 * * * * /home/madlab/charge_controller/venv/bin/renogymodbus --device charge_controller --portname /dev/ttyUSB0 --slaveaddress 17
````
