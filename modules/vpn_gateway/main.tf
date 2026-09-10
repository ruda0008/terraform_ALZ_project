resource "azurerm_public_ip" "vpngw" {
  name                = "pip-vpngw-${var.environment}-${var.resource_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
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


  vpn_client_configuration {
    address_space        = ["172.16.200.0/24"]
    vpn_client_protocols = ["OpenVPN"]



    aad_tenant   = "https://login.microsoftonline.com/${var.tenant_id}"
    aad_audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer   = "https://sts.windows.net/${var.tenant_id}/"
  }

}
