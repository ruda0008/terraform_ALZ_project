

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-${var.resource_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]

}

resource "azurerm_subnet" "main" {
  for_each             = var.subnet_id
  name                 = "${var.environment}-${each.key}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.cidr]
}
