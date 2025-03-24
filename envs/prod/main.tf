locals {
  environment = "prod"
  location    = "northeurope"
  tags        = { Environment = local.environment, ManagedBy = "Pawel", Project = "OpellaInterview" }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.environment}-${local.location}"
  location = local.location
  tags     = local.tags
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-${local.environment}-${local.location}"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnets = {
    subnet1 = { address_prefixes = ["10.0.1.0/24"] }
    subnet2 = { address_prefixes = ["10.0.2.0/24"] }
  }
  tags = local.tags
}

resource "azurerm_storage_account" "storage" {
  name                     = "st${local.environment}${local.location}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}
