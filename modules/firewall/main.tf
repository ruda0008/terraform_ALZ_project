resource "azurerm_public_ip" "firewall" {
  name                = "pip-firewall-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_firewall" "main" {
  name                = "firewall-${var.resource_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier

  ip_configuration {
    name                 = "fw-ipconfig"
    public_ip_address_id = azurerm_public_ip.firewall.id
    subnet_id            = var.subnet_id
  }
}
