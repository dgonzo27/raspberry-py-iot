#!/bin/bash

function usage() {
    echo "Usage: $(basename "$0") [-g <resource group name>] [-s <storage account name>]"
    echo
    echo "Checks for existing backend resources in Azure to maintain Terraform state."
    echo
    echo "Options:"
    echo "---------------------------"
    echo "   -g      Resource Group Name."
    echo "   -s      Storage Account Name."
    exit 1
}

while getopts g:s:e: flag; do
    case "${flag}" in
    g) resource_group_name=${OPTARG} ;;
    s) storage_account_name=${OPTARG,,} ;;
    *) usage ;;
    esac
done

if [[ -z "$resource_group_name" ]]; then
    usage
fi

if [[ -z "$storage_account_name" ]]; then
    usage
fi

echo
echo "Utilizing $resource_group_name resource group."
echo "Checking for existence of $storage_account_name..."
echo

storage_existence=$(az storage account list -g "$resource_group_name" --query "[?name=='$storage_account_name'] | length(@)")

if [[ "$storage_existence" -ne 0 ]]; then
    echo "Storage account ($storage_account_name) was found!"
    echo
else
    echo "Storage account ($storage_account_name) not found, creating..."
    echo
    az storage account create \
        -g "$resource_group_name" \
        --name "$storage_account_name" \
        --sku Standard_LRS \
        --encryption-services blob \
        -o table || exit 1
    echo "Storage account ($storage_account_name) was created successfully!"
    echo
fi

echo "Retrieving storage account key..."
echo

storage_account_key=$(az storage account keys list --resource-group "$resource_group_name" --account-name "$storage_account_name" --query [0].value -o tsv)

echo "Storage account key retrieved!"
echo

container_exists=$(az storage container exists --name terraform-state --account-name "$storage_account_name" --account-key "$storage_account_key" --query exists)

if [[ "$container_exists" = "true" ]]; then
    echo "Storage account container (terraform-state) was found!"
    echo
else
    echo "Storage account container (terraform-state) not found, creating..."
    echo
    az storage container create \
        --name terraform-state \
        --account-name "$storage_account_name" \
        --account-key "$storage_account_key" \
        --public-access off \
        -o table || exit 1
    echo "Storage account container (terraform-state) was created successfully!"
    echo
fi
