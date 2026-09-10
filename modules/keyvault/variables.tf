
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

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "soft_delete_retention_days" {
  type = number
}

variable "purge_protection_enabled" {
  type = bool
}

variable "enable_rbac_authorization" {
  type    = bool
  default = false
}
