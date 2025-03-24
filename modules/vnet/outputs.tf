output "vnet_id" {
  value = azurerm_virtual_network.this.id
}
output "subnets" {
  value = { for k, v in azurerm_subnet.this : k => v }
}
