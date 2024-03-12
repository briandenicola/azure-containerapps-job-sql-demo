resource "azurerm_private_dns_zone" "containerapps" {
  name                = data.azurerm_container_app_environment.this.default_domain
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone" "privatelink_database_windows_net" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_a_record" "containerapps" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.containerapps.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 300
  records             = [ 
    data.azurerm_container_app_environment.this.static_ip_address
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "containerapps" {
  name                  = "${local.resource_name}-aca-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.containerapps.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "${local.resource_name}-sql-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_database_windows_net.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone" "privatelink_azurecr_io" {
  name                      = "privatelink.azurecr.io"
  resource_group_name       = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_azurecr_io" {
  name                      = "${azurerm_virtual_network.this.name}-link"
  private_dns_zone_name     = azurerm_private_dns_zone.privatelink_azurecr_io.name
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_id        = azurerm_virtual_network.this.id
}