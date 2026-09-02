resource "azurerm_resource_group" "main" {
  name     = "${var.resource_name}-${var.environment}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_name}-${var.environment}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  depends_on          = [azurerm_resource_group.main]
}

resource "azurerm_subnet" "main" {
  depends_on           = [azurerm_virtual_network.main]
  name                 = "${var.resource_name}-${var.environment}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = azurerm_virtual_network.main.address_space
}
