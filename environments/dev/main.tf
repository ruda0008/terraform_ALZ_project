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
    key                  = "dev.terraform.tfstate"
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
  name     = "rg-aks-dev"
  location = "West US 2"
}

# networking module
module "networking" {
  source              = "../../modules/networking"
  resource_name       = "aks"
  environment         = "dev"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.address_space
  subnet_id           = var.subnets
}

# aks module

module "aks" {
  source               = "../../modules/aks"
  resource_name        = "aks"
  environment          = "dev"
  virtual_machine_size = var.virtual_machine_size
  location             = azurerm_resource_group.main.location
  subnet_id            = module.networking.subnet_ids["snet-aks"]
  resource_group_name  = azurerm_resource_group.main.name
  workload_identity    = var.workload_identity


}


# VNet Peering

resource "azurerm_virtual_network_peering" "dev-to-hub" {
  name                      = "peer-dev-to-hub"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.networking.virtual_network_name
  remote_virtual_network_id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-hub-dev/providers/Microsoft.Network/virtualNetworks/vnet-hub-dev"


  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true

}

module "keyvault" {
  source                     = "../../modules/keyvault"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  environment                = "dev"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 30
  purge_protection_enabled   = false
}

resource "azurerm_role_assignment" "app_kv_secrets_user" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.aks.workload_identity_principal_id["app"]
}
