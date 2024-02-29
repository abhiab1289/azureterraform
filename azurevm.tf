terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "f79c19b8-ea58-4791-8a62-97a169c178ec"
  client_id       = "b45c4e74-1af1-4958-bed6-ff6f19e057c6"
  client_secret   = "5EZ8Q~nxaS0ip4ftrsO7AVxTSDd.GZF3chPA1bGV"
  tenant_id       = "31f645b1-80dc-4606-8533-a94530909e5c"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "test_rg"
  location = "South India"
  tags = {
    Name = "dev-rg"
  }
}

resource "azurerm_network_security_group" "dev_nsg" {
  name                = "dev-SecurityGroup"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "dev-nsg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  subnet {
    name           = "subnet1"
    address_prefix = "192.168.1.0/24"
  }

  subnet {
    name           = "subnet0"
    address_prefix = "192.168.0.0/24"
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "testterraformdevgroup"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = {
    environment = "dev"
  }
}


resource "azurerm_storage_container" "storage_container" {
  name                  = "tfcontainer"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}


