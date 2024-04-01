data "azurerm_resource_group" "this" {
  name     = var.rg_name
}

data "azurerm_virtual_network" "this" {
  resource_group_name = data.azurerm_resource_group.this.name
  name                = local.virtual_network_name
}

data "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = local.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "nodes" {
  name                 = "nodes"
  virtual_network_name = local.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.this.name
}