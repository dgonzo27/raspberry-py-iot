# raspberry-py-iot terraform

Infrastructure as code to deploy Azure resources related to this solution.

## Table of Contents

- [Pre-Requisites](#pre-requisites)
- [Deploy Infrastructure](#deploy-infrastructure)

## Pre-Requisites

1. You have an [Azure](https://azure.microsoft.com/en-us/) account with a paid subscription, service principal, and existing resource group.

## Deploy Infrastructure

Reference the GitHub Actions Workflow from this repository to deploy terraform - using your parameters and credentials. If you decide to run this through your own GitHub Actions Workflow, you'll need to be sure you create the equivalent `RESOURCE_GROUP`, `STORAGE_ACCOUNT`, `IOTHUB_NAME` and `AZURE_SP_CREDENTIALS` secrets in GitHub.

Alternatively, you can simply install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) and [Terraform CLI](https://developer.hashicorp.com/terraform/cli), login and run the commands seen in the `deploy-terraform.yml` file.
