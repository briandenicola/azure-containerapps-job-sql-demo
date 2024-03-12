resource "azurerm_container_registry" "this" {
  name                     = local.acr_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  sku                      = "Premium"
  admin_enabled            = false
  
}

resource "azurerm_private_endpoint" "acr_account" {
  name                      = "${local.acr_name}-ep"
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  subnet_id                 = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "${local.acr_name}-ep"
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = [ "registry" ]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                          = azurerm_private_dns_zone.privatelink_azurecr_io.name
    private_dns_zone_ids          = [ azurerm_private_dns_zone.privatelink_azurecr_io.id ]
  }
}
