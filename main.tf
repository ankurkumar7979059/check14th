terraform {
  required_version = "~> 1.1"
  
  required_providers {
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "~> 3.0"
    }
  }

}

provider "azurerm" {
  features {}
}

variable "rep_type" {
    type = map
    default = {
        default = "LRS"
        dev = "ZRS"
        prod = "GRS"
    }
}
resource "azurerm_resource_group" "example" {
  name     = format("%s%s","rg", random_integer.suffix.result)
  location = "West Europe"
}
resource "random_integer" "suffix" {
  min = 1000
  max = 9999


}

resource "azurerm_storage_account" "example" {
  name                     = format("%s%s", "storage", random_integer.suffix.result)
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = lookup(var.rep_type,terraform.workspace)

}