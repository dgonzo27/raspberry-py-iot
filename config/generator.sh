#!/bin/bash

#################################################
# NOTE!
# the entrypoint logic and usage of this script
# can be found at the bottom of this file
#################################################

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

################################################################
# function: prepare_filesystem
# help: creates required directories and removes previous files
################################################################
function prepare_filesystem()
{
    rm -rf ${SCRIPT_DIR}/temppackages
    mkdir -p ${SCRIPT_DIR}/temppackages
}

######################################################################
# function: package_install
# help: packages and gzips installation scripts to be run on a device
######################################################################
function package_install()
{
    local device_id="${1}"
    local device_sas="${2}"
    local osx="${3}"

    echo "prepping installation scripts..."
    cp "${SCRIPT_DIR}/scripts/docker-daemon.json" "${SCRIPT_DIR}/temppackages/docker-daemon.json"
    cp "${SCRIPT_DIR}/scripts/iotedge-install.sh.template" "${SCRIPT_DIR}/temppackages/iotedge-install.sh"

    if [[ -z "$osx" ]]; then
        sed -i "s|<DEVICE_CNX_STR>|${device_cnx_str}|" "${SCRIPT_DIR}/temppackages/iotedge-install.sh"
    else
        sed -i "" "s|<DEVICE_CNX_STR>|${device_cnx_str}|" "${SCRIPT_DIR}/temppackages/iotedge-install.sh"
    fi
    echo "prep complete!"
    echo ""

    echo "zipping and storing packaged scripts..."
    echo ""
    cwd=$(pwd)

    # cloud zip
    echo "zipping ${device_id}-setup.tar.gz"
    cd "${SCRIPT_DIR}/temppackages"
    tar -czvf cloud.tar.gz *
    cd "${cwd}"
    mv "${SCRIPT_DIR}/temppackages/cloud.tar.gz" "packages/${device_id}-setup.tar.gz"
    echo ""
    echo "${device_id}-setup.tar.gz complete!"
    echo ""
    echo "generator script is done!"
}

#####################
# ENTRYPOINT LOGIC! #
#####################

# input args
device_id="${1}"
device_cnx_str="${2}"
osx="${3}"

# 1. prep filesystem
prepare_filesystem

# 2. generate and package scripts
package_install \
    ${device_id} \
    ${device_cnx_str} \
    ${osx}
