output "inbound_ip_address" {
  value = azurerm_private_dns_resolver_inbound_endpoint.main.ip_configurations[0].private_ip_address
}
