variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  nullable    = false
}

variable "vnet_location" {
  description = "The location of the vnet to create."
  type        = string
  nullable    = false
}

variable "location_short_name" {
    description = "Shot name of location, approved locations short names ae and ase"
    type = string
    default = "ae"
}

variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
  default     = ""
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = [] //["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Type of environment"
  type        = string
  default     = ""
}

variable "solution_name" {
  description = "Name of the solution"
  type        = string
  default     = ""
}

variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs"
  type        = map(string)

  default = {
  }
}

variable "route_tables_ids" {
  description = "A map of subnet name to Route table ids"
  type        = map(string)
  default     = {}
}

variable "subnet_delegation" {
  description = "A map of subnet name to delegation block on the subnet"
  type        = map(map(any))
  default     = {}
}

variable "subnet_enforce_private_link_endpoint_network_policies" {
  description = "A map of subnet name to enable/disable private link endpoint network policies on the subnet."
  type        = map(bool)
  default     = {}
}

variable "subnet_enforce_private_link_service_network_policies" {
  description = "A map of subnet name to enable/disable private link service network policies on the subnet."
  type        = map(bool)
  default     = {}
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = []
}

variable "subnet_service_endpoints" {
  description = "A map of subnet name to service endpoints to add to the subnet."
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "The tags to associate with RG and other resources."
  type        = map(string)

  default = {
    env = "dev"
  }
}

variable "common_tags" {
  description = "Common tags applied to all the resources created in this module"
  type        = map(string)
}

