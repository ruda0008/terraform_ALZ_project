

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.resource_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]

}

resource "azurerm_subnet" "main" {
  for_each             = var.subnet_id
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.cidr]

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = "delegation"
      service_delegation {
        name = delegation.value
      }
    }
  }

}


