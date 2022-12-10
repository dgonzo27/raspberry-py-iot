variable "resource_group_name" {
  description = "The name of the Azure resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the Azure resource group."
  type        = string
  default     = "eastus2"
}

variable "service_principal_secret" {
  description = "The client secret for the Azure service principal."
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "The name of the Azure storage account."
  type        = string
}

variable "iothub_name" {
  description = "The name of the Azure IoT Hub."
  type        = string
}
