resource "azurerm_resource_group" "main" {
  name     = "${var.resource_name}-${var.environment}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-${var.resource_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.address_space]

}

resource "azurerm_subnet" "main" {
  for_each             = var.subnet_id
  name                 = "snet-${var.environment}-${each.key}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.cidr
}
