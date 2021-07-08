# En el fichero main.tf incluiremos el código Terraform con los datos del provider y crearemos:
# - El grupo de recursos donde crearemos toda la infraestructura necesaria.
# - Una Storage account para almacenar información sobre el despliegue.

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.63.0"
    }
  }
}

# Resource group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "rg" {
  name     = "kubernetes_resources"
  location = var.location

  tags = {
    environment = "dev"
  }
}

# Storage account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "myStorageAccount" {
  # storage account name is UNIQUE in all Azure, can only consist of
  # lowercase letters and numbers, and must be between 3 and 24 characters long
  name                     = var.storage_account
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
      environment = "dev"
  }
}
