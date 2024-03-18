resource "azurerm_route_table" "this" {
    count                         = var.deploy_firewall ? 1 : 0
    name                          = "${local.resource_name}-routetable"
    resource_group_name           = azurerm_resource_group.this.name
    location                      = azurerm_resource_group.this.location
    disable_bgp_route_propagation = true

    route {
        name                   = "DefaultRoute"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = azurerm_firewall.this[0].ip_configuration[0].private_ip_address
    }
}

resource "azurerm_subnet_route_table_association" "cqrs_region" {
    count          = var.deploy_firewall ? 1 : 0
    subnet_id      = azurerm_subnet.nodes.id
    route_table_id = azurerm_route_table.this[0].id
}
