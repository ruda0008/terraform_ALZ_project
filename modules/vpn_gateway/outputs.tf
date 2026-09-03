output "vpn_gateway_public_ip" {
  value = azurerm_public_ip.vpngw.ip_address

}

output "gateway_id" {
  value = azurerm_virtual_network_gateway.main.id
}
