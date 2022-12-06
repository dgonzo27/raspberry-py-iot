# Raspberry Py IoT Config

IoT Edge Runtime Installer (shell scripts).

## Configuration Steps

### Create Edge Devices

Before we can start the installation and configuration of our IoT Edge devices, these devices need to first exist in our IoT Hub so that the physical devices (virtual machines) running our software has something to authenticate against.

Reference the GitHub Actions Workflow from this repository to create IoT edge devices - using your parameters and credentials.

### Generate Installation Packages

The remaining steps should be run from the unix machine that this repository was cloned to.

This step will generate packages that contain installation scripts. These scripts will install the latest version of Azure's IoT Edge Runtime.

Run the script to create, package and gzip the installation scripts.

```sh
# SCRIPT ARGUMENTS:
# 1 - Edge Device ID - ex: my-edge-device-id
# 2 - Edge Device Connection String - ex: b8le********
# 3 - Running on OSX? - ex: true or false

bash ./scripts/generator.sh \
    "my-edge-device-id" \
    "edgeDeviceCnxStr" \
    "false"
```

### Installation of Packages

After generating the installation packages in the previous step, it's now time to install these packages on the device hardware.

Run the following commands.

```sh
# create a folder for the package
ssh root@10.0.0.185 'if [ -d ~/iotedge-setup ]; then rm -rf ~/iotedge-setup/*; else mkdir ~/iotedge-setup; fi'

# transfer the package
scp "packages/my-edge-device-id-setup.tar.gz" "root@10.0.0.185:iotedge-setup/setup.tar.gz"

# unzip the package
ssh root@10.0.0.185 'cd iotedge-setup; tar -xzvf setup.tar.gz'

# run the installation package
ssh root@10.0.0.185 'cd iotedge-setup; sudo sh iotedge-install.sh'
```

SSH into the device to confirm the installation and status of the edge device. It is recommended to wait 3-5 minutes after the installation script has completed before running the confirmation steps listed below.

```sh
# print out the active configuration that was applied by our script
sudo cat /etc/aziot/config.toml

# run an IoT Edge system status check
sudo iotedge system status

# run an IoT Edge configuration check
sudo iotedge check --verbose

# list active IoT Edge modules
sudo iotedge list
```
