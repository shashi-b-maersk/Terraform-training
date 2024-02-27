terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    #if nothing specified, that means use the default feature
  }
  skip_provider_registration = true
}

data "azurerm_resource_group" "example" {
  name = "rg-smi262-tfworkshop"
}

resource "azurerm_storage_account" "example" {
  name                     = "smi262tfworkshopstorageaccount"
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

output "name" {
  value = data.azurerm_resource_group.example.location
}
