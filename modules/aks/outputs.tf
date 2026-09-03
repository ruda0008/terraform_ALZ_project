output "cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "workload_identity_client_id" {
  value       = { for k, id in azurerm_user_assigned_identity.main : k => id.client_id }
  description = "Map of app name to its Azure Managed Identity Client ID"
}

