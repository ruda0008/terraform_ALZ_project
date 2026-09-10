resource "azurerm_private_dns_resolver" "main" {
  name                = "dns-resolver-${var.resource_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.virtual_network_id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "main" {
  name                    = "inbound-${var.resource_name}-${var.environment}"
  private_dns_resolver_id = azurerm_private_dns_resolver.main.id
  location                = var.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = var.subnet_id
  }
}
