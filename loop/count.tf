terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
  backend "local" {
    path = "./backend/terraform.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {
    #if nothing specified, that means use the default feature
  }
  skip_provider_registration = true
}

resource "azurerm_resource_group" "example" {
  name = "smi262"
  location = "west europe"
}

variable "user_names" {
  description = "Create storage account with these names"
  type        = list(string)
  default     = ["smimaersk262101", "smimaersk262102","smimaersk262104","smimaersk262103"]
}

resource "azurerm_storage_account" "example" {
  count                    = 4
  name                     = var.user_names[count.index]
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

output "name" {
  value = azurerm_resource_group.example.location
  description = "Azure rm resource group location"
}
