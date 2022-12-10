### main.tf ###
# This files contains the Azure resources for this solution.

# Storage container for IoT Hub output
resource "azurerm_storage_container" "iothub_output" {
  name                 = "iot-hub-output"
  storage_account_name = data.azurerm_storage_account.storage.name
}

# IoT Hub
resource "azurerm_iothub" "iothub" {
  name                = var.iothub_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku {
    name     = "S1"
    capacity = 1
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = data.azurerm_storage_account.storage.primary_blob_connection_string
    name                       = "sensor-filter-endpoint"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = azurerm_storage_container.iothub_output.name
    encoding                   = "JSON"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  }

  route {
    name           = "sensor-filter-route"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["sensor-filter-endpoint"]
    enabled        = true
  }
}
