data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.resource_name}-${var.environment}-${random_string.suffix.result}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku_name                   = var.sku_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled
  enable_rbac_authorization  = var.enable_rbac_authorization
}
