
variable "subscription_id" {
  type = string

}

variable "subnets" {
  type = map(object({
    cidr       = string
    delegation = optional(string)
  }))
}

variable "address_space" {

  type        = string
  description = "CIDR for vnet"
}

variable "environment" {
  type        = string
  description = "enviroment variable"
  default     = "dev"
}
variable "tenant_id" {
  type = string
}

