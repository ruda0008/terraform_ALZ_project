variable "resource_name" {
  type        = string
  description = "Name of the resource group"
}
variable "location" {
  type        = string
  description = "Location of the resource group"
  default     = "West US 2"
}
variable "resource_group_name" {
  type = string
}

variable "environment" {
  type        = string
  description = "enviroment variable"
  default     = "dev"
}


variable "virtual_network_id" {
  type        = string
  description = "Virtual Network ID of the Hub"
}
variable "subnet_id" {
  type        = string
  description = "Subnet ID of the delegated DNS inbound subnet"
}
