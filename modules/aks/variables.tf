
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
  type        = string
  description = "ID of the subnet in which the AKS cluster will be deployed"

}

variable "workload_identity" {

  type = map(object({
    namespace       = string
    service_account = string
  }))
  default     = {}
  description = "Map of application workload identities to creat and federate"
}
