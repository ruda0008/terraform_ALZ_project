resource "azurerm_public_ip" "vpngw" {
  name                = "pip-vpngw-${var.environment}-${var.resource_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "main" {
  name                = "vpngw-${var.environment}-${var.resource_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = var.sku_name

  ip_configuration {
    name                 = "VnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.vpngw.id
    subnet_id            = var.subnet_id
  }



}
