resource "azurerm_mssql_server" "this" {
  name                         = "${local.resource_name}-sql"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "manager"
  administrator_login_password = random_password.password.result
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = data.azurerm_client_config.current.object_id
  }

}

resource "azurerm_mssql_database" "this" {
  name                = "todo"
  server_id           = azurerm_mssql_server.this.id
}

resource "azurerm_mssql_firewall_rule" "home" {
  name             = "AllowHomeNetwork"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "${chomp(data.http.myip.response_body)}"
  end_ip_address   = "${chomp(data.http.myip.response_body)}"
}

resource "azurerm_private_endpoint" "sql" {
  name                      = "${local.sql_name}-ep"
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  subnet_id                 = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "${local.sql_name}-ep"
    private_connection_resource_id = azurerm_mssql_server.this.id
    subresource_names              = [ "sqlServer" ]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                          = azurerm_private_dns_zone.privatelink_database_windows_net.name
    private_dns_zone_ids          = [ azurerm_private_dns_zone.privatelink_database_windows_net.id ]
  }
}
