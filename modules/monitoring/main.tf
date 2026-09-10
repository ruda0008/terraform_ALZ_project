resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.resource_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_name
  retention_in_days   = var.retention_days

}
