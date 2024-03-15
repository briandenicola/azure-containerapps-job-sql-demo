output "RESOURCE_GROUP" {
    value = azurerm_resource_group.this.name
    sensitive = false
}

output "APP_NAME" {
    value = local.resource_name
    sensitive = false
}

output "ACR_NAME" {
    value = local.acr_name
    sensitive = false
}

output "LAW_ID" {
    value = azurerm_log_analytics_workspace.this.workspace_id
    sensitive = false
}

output "SQL_SERVER_NAME" {
    value = azurerm_mssql_server.this.name
    sensitive = false
}

output "SQL_SERVER_FQDN" {
    value = azurerm_mssql_server.this.fully_qualified_domain_name
    sensitive = false
}