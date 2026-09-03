terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatedevruda0008"
    container_name       = "tfstate"
    key                  = "hubterraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {

}

# resource group for DEV
resource "azurerm_resource_group" "main" {
  name     = "rg-hub-dev"
  location = "West US 2"
}

# networking module
module "networking" {
  source              = "../../modules/networking"
  resource_name       = "hub"
  environment         = "dev"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.address_space
  subnet_id           = var.subnets
}


# Bastion Module
module "bastion" {
  source              = "../../modules/bastion"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  resource_name       = "hub"
  subnet_id           = module.networking.subnet_ids["AzureBastionSubnet"]
  environment         = "dev"

}
# Firewall module
module "firewall" {
  source              = "../../modules/firewall"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_tier            = "Standard"
  environment         = "dev"
  resource_name       = "hub"
  sku_name            = "AZFW_VNet"
  subnet_id           = module.networking.subnet_ids["AzureFirewallSubnet"]
}

# VPN Gateway module

module "vpn_gateway" {
  source              = "../../modules/vpn_gateway"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  resource_name       = "hub"
  environment         = "dev"
  subnet_id           = module.networking.subnet_ids["GatewaySubnet"]
  sku_name            = "VpnGw1"

}
