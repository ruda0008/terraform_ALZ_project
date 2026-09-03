

resource "azurerm_kubernetes_cluster" "main" {
  name                      = "aks-${var.environment}-01"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = "aks-${var.environment}-01"
  private_cluster_enabled   = true
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name                 = "system"
    node_count           = 1
    vm_size              = "Standard_D2s_v3"
    vnet_subnet_id       = var.subnet_id
    auto_scaling_enabled = true
    max_count            = 3
    min_count            = 1
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "192.168.0.0/16"
    dns_service_ip = "192.168.0.10"

  }

}


resource "azurerm_user_assigned_identity" "main" {
  for_each            = var.workload_identity
  name                = "id-${each.key}-${var.environment}-${var.resource_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "main" {
  for_each            = var.workload_identity
  name                = "fic-${each.key}-${var.environment}-${var.resource_name}"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.main[each.key].id
  issuer              = azurerm_kubernetes_cluster.main.oidc_issuer_url
  subject             = "system:serviceaccount:${each.value.namespace}:${each.value.service_account}"
  audience            = ["api://AzureADTokenExchange"]

}
