### provider.tf ###
# This file manages the azure provider and backend for our IaC.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
}

terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
