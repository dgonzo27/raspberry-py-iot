#!/bin/bash

#################################################
# NOTE!
# the entrypoint logic and usage of this script
# can be found at the bottom of this file
#################################################

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

############################################
# function: configure_device
# help: full installation on an edge device
############################################
function configure_device()
{
    local package_name="${1}"
    local device_ip="${2}"
    local device_user="${3}"

    echo "prepping file transfer to edge device target..."
    ssh "${device_user}@${device_ip}" 'if [ -d ~/iotedge-setup ]; then rm -rf ~/iotedge-setup/*; else mkdir ~/iotedge-setup; fi'

    echo "transferring package..."
    scp "packages/${package_name}" "${device_user}@${device_ip}:iotedge-setup/setup.tar.gz"

    echo "unpacking contents..."
    ssh "${device_user}@${device_ip}" 'cd iotedge-setup; tar -xzvf setup.tar.gz'

    echo "contents have been unpacked and are waiting execution from a superuser!"
}

#####################
# ENTRYPOINT LOGIC! #
#####################

# input args
device_id="${1}"
device_ip="${2}"
device_user="${3}"

# run the configure_device function
configure_device \
    "$device_id-setup.tar.gz" \
    "$device_ip" \
    "$device_user"
