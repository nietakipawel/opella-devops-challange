# Azure VNET Terraform Module

This module provisions an Azure Virtual Network (VNET) with configurable subnets.

## Usage Example

```hcl
module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "${vnet_name}"
  location            = "${location}"
  resource_group_name = "${resource_group_name}"
  address_space       = ${jsonencode(address_space)}
  
  subnets = ${jsonencode(subnets)}
  
  tags = ${jsonencode(tags)}
}
```

# Azure VNET Terraform Module - Inputs and Outputs

## Inputs

| Name                   | Description                                        | Type                         | Default | Required |
|------------------------|----------------------------------------------------|------------------------------|---------|----------|
| `vnet_name`             | The name of the virtual network                    | `string`                     | n/a     | yes      |
| `location`             | The Azure region where the VNET will be deployed    | `string`                     | n/a     | yes      |
| `resource_group_name`  | The name of the resource group                     | `string`                     | n/a     | yes      |
| `address_space`        | A list of address spaces for the VNET               | `list(string)`               | n/a     | yes      |
| `subnets`              | A map of subnets with address prefixes              | `map(object({ address_prefixes = list(string) }))` | n/a     | yes      |
| `tags`                 | Tags to associate with the VNET                     | `map(string)`                | `{}`    | no       |
| `nsg_rules`            | A list of NSG rules to apply to each subnet        | `list(object({...}))`        | Default to deny rule | no       |

## Outputs

| Name         | Description                                             | Value                                                   |
|--------------|---------------------------------------------------------|---------------------------------------------------------|
| `vnet_id`    | The ID of the created Virtual Network                    | `azurerm_virtual_network.this.id`                        |
| `subnet_ids` | A map of subnet names and their corresponding subnet IDs  | `{ for k, v in azurerm_subnet.this : k => v.id }`         |






## Network Diagram

```mermaid
graph TD;
  VNET[Azure Virtual Network] -->|Subnet 1| Subnet1
  VNET -->|Subnet 2| Subnet2
```