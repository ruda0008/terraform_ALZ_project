output "resource_group_name" {
  value = var.resource_group_name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  value = { for k, i in azurerm_subnet.main : k => i.id }
}
