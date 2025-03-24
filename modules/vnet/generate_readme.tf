resource "local_file" "readme" {
  content = templatefile("${path.module}/README.tpl", {
    vnet_name           = var.vnet_name
    location            = var.location
    resource_group_name = var.resource_group_name
    address_space       = var.address_space
    subnets             = var.subnets
    tags                = var.tags
  })
  filename = "${path.module}/README.md"
}
