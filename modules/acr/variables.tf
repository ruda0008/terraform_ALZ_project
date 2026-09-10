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
  default = "Basic"
}

variable "admin_enabled" {
  type    = bool
  default = true
}
