resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}
resource "azurerm_container_registry" "main" {
  name                = "acr${var.environment}${random_string.suffix.result}"
  sku                 = var.sku_name
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_enabled       = var.admin_enabled
}
