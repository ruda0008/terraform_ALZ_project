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
