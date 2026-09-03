
variable "subscription_id" {
  type = string

}

variable "subnets" {
  type = map(object({
    cidr = string
  }))
}

variable "address_space" {
  type        = string
  description = "CIDR for vnet"
}

variable "workload_identity" {

  type = map(object({
    namespace       = string
    service_account = string
  }))
  default     = {}
  description = "Map of application workload identities to creat and federate"
}
