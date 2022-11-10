variable "environment" {
  description = "Type of environment"
  type        = string
  default     = "poc"
}

variable "solution_name" {
  description = "Name of the solution"
  type        = string
  default     = "centric"
}

variable "location_short_name" {
    description = "Shot name of location, approved locations short names ae and ase"
    type = string
    default = "ae"
}

variable "location_short_name_ase" {
    description = "Shot name of location, approved locations short names ae and ase"
    type = string
    default = "ase"
}

variable "vnet_location" {
  description = "The location of the vnet to create."
  type        = string
  default = "Australia East"
  nullable    = false
}

variable "location" {
  description = "The location of the vnet to create."
  type        = string
  default = "Australia East"
  nullable    = false
}

variable "common_tags" {
  description = "Common tags applied to all the resources created in this module"
  type        = map(string)
  default     = {}
}

variable "gateway_address" {
  description = "Gateway IP address for the default route"
  type        = string
  default = "10.166.5.4"
}

