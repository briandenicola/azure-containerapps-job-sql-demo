resource "azurerm_route_table" "this" {
    name                          = local.route_table_name
    resource_group_name           = data.azurerm_resource_group.this.name
    location                      = data.azurerm_resource_group.this.location
    disable_bgp_route_propagation = true

    route {
        name                   = "DefaultRoute"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = azurerm_firewall.this.ip_configuration[0].private_ip_address
    }
}

resource "azurerm_subnet_route_table_association" "this" {
    subnet_id      = data.azurerm_subnet.nodes.id
    route_table_id = azurerm_route_table.this.id
}
