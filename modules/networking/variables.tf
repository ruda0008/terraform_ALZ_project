
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

variable "subnet_id" {
  type = map(object({
    cidr = string

  }))
  description = "map of subnets to create "

}

variable "address_space" {
  type        = string
  description = "CIDR for vnet"

}

