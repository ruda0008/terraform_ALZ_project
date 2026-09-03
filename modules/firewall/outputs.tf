output "firewall_id" {
  value = azurerm_firewall.main.id


}

output "firewall_public_ip" {
  value = azurerm_public_ip.firewall.ip_address
}
