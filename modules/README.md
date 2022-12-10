# raspberry-py-iot modules

IoT Edge Python Modules to send telemetry data up to the IoT Hub.

## Table of Contents

- [Pre-Requisites](#pre-requisites)
- [Getting Started](#getting-started)
- [Deploy Modules](#deploy-modules)
- [Update Edge Device](#update-edge-device)

## Pre-Requisites

1. You have a [Docker Hub](https://hub.docker.com) account and have created an access token in your account settings (be sure to save this token somewhere safe for later use).

2. You have installed (Docker Desktop)[https://www.docker.com/products/docker-desktop/] and (Python3)[https://www.python.org/downloads/] in a unix development environment.

## Getting Started

1. Visit the `docker-compose.yml` file and replace the `DEV_IOTHUB_DEVICE_CONNECTION_STRING` with your IoT Edge Device's connection string.

2. Build and Run the Docker container.

   ```sh
   docker compose build && docker compose up
   ```

3. Stop the Docker container.

   ```sh
   ctrl + c # hit the control and c key on your keyboard at the same time

   docker compose down # once that finishes, run this command to kill the containers ~ gracefully ~
   ```

## Deploy Modules

Before we can configure and run the module on our IoT Edge device, the module's image needs to first exist in a Docker registry.

Reference the GitHub Actions Workflow from this repository to deploy modules - using your parameters and credentials. If you decide to run this through your own GitHub Actions Workflow, you'll need to be sure you create the equivalent `DOCKERHUB_USER` and `DOCKERHUB_TOKEN` secrets in GitHub.

Alternatively, you can simply login to Docker from your CLI and build and push the image yourself.

## Update Edge Device

Reference the GitHub Actions Workflow from this repository to update the edge device - using your parameters and credentials. If you decide to run this through your own GitHub Actions Workflow, you'll need to be sure you create the equivalent `DOCKERHUB_USER` and `AZURE_SP_CREDENTIALS` secrets in GitHub.

Alternatively, you can simply install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/), login and run the commands seen in the `update-edge-device.yml` file.
