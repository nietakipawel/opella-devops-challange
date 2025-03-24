variable "vnet_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "address_space" {}
variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}
variable "tags" {}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "deny_all"
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
