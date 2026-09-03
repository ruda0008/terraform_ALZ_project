

variable "subnet_id" {
  type = string
}

variable "location" {
  type        = string
  description = "Location of the resource group"
  default     = "West US 2"
}

variable "resource_name" {
  type        = string
  description = "Name of the resource"
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "AZFWL3"

}

variable "sku_tier" {
  type    = string
  default = "Basic"
}


variable "environment" {
  type        = string
  description = "enviroment variable"
  default     = "dev"
}


