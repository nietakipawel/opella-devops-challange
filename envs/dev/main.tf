
locals {
  environment = "dev"
  location    = "westeurope"
  tags        = { environment = local.environment, ManagedBy = "Pawel", Project = "OpellaInterview" }
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


resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${local.environment}-${local.location}"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.vnet.subnets["subnet1"].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${local.environment}-${local.location}"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]
  size = "Standard_B1s"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_username = "azureuser"

  tags = local.tags
}
