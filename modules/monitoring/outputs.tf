output "workspace_id" {
  value       = azurerm_log_analytics_workspace.main.workspace_id
  description = "Log Analytics Workspace ID"
}

output "id" {
  value       = azurerm_log_analytics_workspace.main.id
  description = "Log Analytics Workspace ID"
}

output "primary_shared_key" {
  value     = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive = true
}
