# Pi Charge Controller Setup

This repository extends a Pi already running `dendro-pi-main` by adding support for logging and uploading solar charge controller data. 
The file is saved in CSV format with a timestamp to differentiate each day's data for the upload script.
It also controls a relay to turn on/off a load based on the charge controller temperature.

The default behaviour of this system is to log the charge controller data every 5 minutes and upload it to Dropbox every 30 minutes.

Example output of the CSV file:
| Timestamp           | Controller Temp (°C) | Battery Voltage (V) | State of Charge (%) | Relay State (On=True) | Solar Voltage (V) | Solar Current (A) | Solar Power (W) | Battery Temp (°C) | Max Solar Today (W) | Min Solar Today (W) | Max Battery V Today (V) | Min Battery V Today (V) |
|---------------------|----------------------|---------------------|---------------------|-----------------------|-------------------|-------------------|-----------------|-------------------|---------------------|---------------------|-------------------------|-------------------------|
| 2025-06-09T00:00:02.523821 | 20                   | 12.3                | 56                  | False                 | 0                 | 0                 | 0               | 25                | 5                   | 0                   | 12.6                    | 12.2                    |

---
## Prerequisites
- Make sure you have followed the initial setup instructions from: https://github.com/alanfogel/dendro-pi-main
- Required hardware:
  - Raspberry Pi (any model with USB ports)
  - Renogy Solar Charge Controller with RS232 port (e.g., Renogy Adventurer, Renogy Wanderer, etc.)
  - [RJ12 6P6C Male to 6 Pin Screw Terminals](https://www.amazon.ca/Ethernet-Adapter-Connector-Screw-Terminals/dp/B07XRH76Z5?crid=2MKLG3GI6862B&dib=eyJ2IjoiMSJ9.ZOZstqEAoJ938EsjzsER_lnuVbjRA3dPEEwtDhe1S52GcOMFr4h_LBG-03DhrkkI-EWpnKC8dDLlIjYwSB8A1k_71ohNxt_Z7ClXUsRrIFMZbULfJHd3HpauiMpdgq98akKn2haChJ-WixzwMPFssP9sztXvfjKTCG3ql7pQVAO9r2G35DLld8N0qlLAcMwXKRiXw4CLXzycmi69itokTL4niNc1wPq2XS6EMLPf-xJVWtcKsEWwHUSTYsozLW0wnqf8RbJzw-m3s38FNM_Vd6YnxWXIgFrB8BTQ47tYyzg.YW-WrzMVRLKTSU9OURE6w-gOdRvXTjSFs3lzc-Ygf14&dib_tag=se&keywords=RJ12+Male+Plug+to+6+Pin+Screw+Terminal+Connector&qid=1749566060&sprefix=rj12+male+plug+to+6+pin+screw+terminal+connector%2Caps%2C152&sr=8-6)
  - [Waveshare USB to RS232/485 Serial Converter](https://www.amazon.ca/Waveshare-USB-Converter-Transmission-Compatible/dp/B0CTK7YZQK?crid=2GJ26LO91O49K&dib=eyJ2IjoiMSJ9.kUTrKni4FIPjK8pYNyWoOIxJ0efL4y8y1QOwuvpqmP7i_oBbeWnxg1KCrFPPoOxEannKu-kv4JrnyzNNnLZJ2wTp_kSaGKUi7UDFvHdti7SsDLRUDSBeFMWKKyVtvsNUZf8BPKnZlf_5tbfRyvJVQFOUSS9RpNef7JC5xfiJ4udWRd1jQXPyDE38s1URAG6D2CCxHz1Ph7apTfTq-M-9m0HWYRWQ2-NvbX50AvxmuUdbCu8FUlUd4W2xGh3B9JaQDidoP_7duSwyGKpSkpfYODejrrzeOiav89frKLDgDis.yeXV8PFcbkDW1delV8LbgZoPJWRzthaJPUPl0fZZ7Ns&dib_tag=se&keywords=Waveshare+USB+to+RS232&qid=1749566038&sprefix=waveshare+usb+to+rs232%2Caps%2C353&sr=8-6)
  - [Male Micro USB to Female USB adapter](https://www.amazon.ca/Adapter-Samsung-Controller-Android-Smartphone/dp/B07CR3PCVB?crid=2OVD4DL5UEU3J&dib=eyJ2IjoiMSJ9.FqVlm6jNhvtTLzeE5VQzaTqnC02JFGJfEOnhrHbctx2w0zYWA-p65KxHi2D3jcP59drfEbpK4eXjtMCR3jhCWvx7XFpe8aKACIcGK9jQwkrS8QMSOddqz0wiih4HBIk6wrw8WG_JTJefS97iKU1zV2ga6_lZR5LRFFQpcN3H5_Gtiay_h_K9UD9vESVX7LKvOaDQiynbKR8KRlBqAEsfuQQB6tX5YGwtM15XC3bRXb1VVQxS5EyoaISW-PLwyQkooPLGygHSE8cFfw-rOEh86vB14MjSH4dWQKTdtx1rsN0.FbaNrS3Ouz6oN6iNQS1lxPOaQec_Bxs4CGUWzkj67P4&dib_tag=se&keywords=usb%2Bfemale%2Bto%2Bmicro%2Busb&qid=1749566114&sprefix=usb%2Bfemale%2Bto%2Bmicro%2Busb%2Caps%2C191&sr=8-7&th=1) ***(Raspberry Pi Zero W)***
  - [Iot Relay - Enclosed High-Power Power Relay](https://www.amazon.ca/Iot-Relay-Enclosed-High-power-Raspberry/dp/B00WV7GMA2?crid=3B640OEDEQ2B1&dib=eyJ2IjoiMSJ9.esvDEOgIFIlxwxw5YnbzBLnD8foV8uX2yzJBmPkHi6U.krrfZr13Pm6OEa-6MBo62_Ib18VyR77FtVf6YnIaF2U&dib_tag=se&keywords=iotrelay+digital+loggers&qid=1749567017&sprefix=iotrelay+digital+logger%2Caps%2C196&sr=8-2-fkmr0) ***(Only if you want to control a load based on the charge controller output)***
---
## 🔧 Physical Setup instructions
### 1. Connect the Solar Charge Controller to the Raspberry Pi
- The RJ12 adapter connects to the RS232 port on the charge controller.
- The other end of the RJ12 adapter has 6 screw terminals. We only need to connect 3 of them:
  - **Pin 1**: Connect to the **RX** pin of the Waveshare USB to RS232/485 Serial Converter.
  - **Pin 2**: Connect to the **TX** pin of the Waveshare USB to RS232/485 Serial Converter.
  - **Pin 3**: Connect to the **GND** pin of the Waveshare USB to RS232/485 Serial Converter.
  #### Note: The pins are numbered from left to right when looking at the RJ12 connector with the screw terminals facing you. 
  #### Note2: The RX and TX pins are reversed, so make sure to connect them correctly.
- The Waveshare USB to RS232/485 Serial Converter connects to the Raspberry Pi via USB.
  - If using a Raspberry Pi Zero W, you will need the USB to Micro USB adapter.

### 2. Connect the Relay
- The relay is connected to the Raspberry Pi header pins.
  - Wire the relay as follows:
    - **IN**: Connect to GPIO pin 10 (or any other GPIO pin you prefer). ***If you use a different GPIO pin, you will need to change the variable ```RELAY_PIN = 10``` in ```command_line.py```***
    - **GND**: Connect to a ground pin on the Raspberry Pi.


## 🔧 Raspberry Pi Setup Instructions

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
- Change line 5: ```DROPBOX_FOLDER="/Dorval-Solar_TEST```
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
---
## Instructions for Using the Relay
1. Open the `command_line.py` file:
```bash
nano command_line.py
```
2. Find the lines that set the temperature thresholds for the relay:
```python
TEMP_ON_THRESHOLD = 23
TEMP_OFF_THRESHOLD = 24
```

3. Adjust the values of `TEMP_ON_THRESHOLD` and `TEMP_OFF_THRESHOLD` to your desired temperature thresholds. 
   - The relay will turn on when the charge controller temperature exceeds `TEMP_ON_THRESHOLD` and will turn off when it falls below `TEMP_OFF_THRESHOLD`.

4. If you want to change what triggers the relay, you can modify the logic in the function `print_charge_controller_output()` 
   ````python
   def print_charge_controller_output(args):
       # ... existing code ...
           relay_state = None
            if controller_temp > TEMP_ON_THRESHOLD:
               set_relay(True)
               relay_state = True
            elif controller_temp < TEMP_OFF_THRESHOLD:
               set_relay(False)
               relay_state = False
       # ... existing code ...
   ````
   
   - For example, you can change the condition to check for battery voltage or state of charge instead of temperature by modifying the `if` statements accordingly.


5. Save the file and exit the editor (Ctrl + X, then Y, then Enter).

---
## Troubleshooting
1. ```minimalmodbus.NoResponseError: No communication with the instrument (no answer)```
   - The ```slaveaddress #``` argument in crontab may be in correct. The default is 1, but it may be different for your setup. A previous setup I had used the address 17.

2. If the relay is not working as expected:
   - Ensure the relay is connected to the correct GPIO pin, or change the `RELAY_PIN` variable in `command_line.py` to match your setup.
---
