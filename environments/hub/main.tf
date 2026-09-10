terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terrafrom-state-rg"
    storage_account_name = "tfstatedevruda0008"
    container_name       = "tfstate"
    key                  = "hub.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
data "azurerm_client_config" "current" {}

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
  sku_name            = "VpnGw1AZ"
  tenant_id           = var.tenant_id


}


# VNet Peering

resource "azurerm_virtual_network_peering" "hub-to-dev" {
  name                      = "peer-hub-to-dev"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.networking.virtual_network_name
  remote_virtual_network_id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-aks-dev/providers/Microsoft.Network/virtualNetworks/vnet-aks-dev"


  allow_virtual_network_access = true
  allow_gateway_transit        = true
  allow_forwarded_traffic      = true


}

module "dns_resolver" {
  source              = "../../modules/dns_resolver"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  resource_name       = "hub"
  environment         = "dev"
  virtual_network_id  = module.networking.virtual_network_id
  subnet_id           = module.networking.subnet_ids["dnsInboundSubnet"]
}

resource "azurerm_virtual_network_dns_servers" "main" {
  virtual_network_id = module.networking.virtual_network_id
  dns_servers        = [module.dns_resolver.inbound_ip_address]
}

# Link Hub VNet to AKS Private DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "hub_to_aks" {
  name                  = "link-hub-to-aks"
  resource_group_name   = data.azurerm_kubernetes_cluster.aks.node_resource_group
  private_dns_zone_name = data.azurerm_resources.aks_dns_zone.resources[0].name
  virtual_network_id    = module.networking.virtual_network_id
}

# Log analytics module

module "log_analytics" {
  source              = "../../modules/monitoring"
  resource_group_name = azurerm_resource_group.main.name
  retention_days      = 30
  location            = azurerm_resource_group.main.location
  environment         = "dev"
  resource_name       = "hub"
}

