
# create public ip for bastion host
resource "azurerm_public_ip" "main" {
  name                = "pip-bastion-${var.resource_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_bastion_host" "main" {
  name                = "bastion-${var.resource_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_ids
    public_ip_address_id = azurerm_public_ip.main.id
  }

}
