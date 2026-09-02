
variable "resource_name" {
  type        = string
  description = "Name of the resource group"
}
variable "location" {
  type        = string
  description = "Location of the resource group"
  default     = "West US 2"
}

variable "environment" {
  type        = string
  description = "envirotnment variable"
  default     = "dev"
}
