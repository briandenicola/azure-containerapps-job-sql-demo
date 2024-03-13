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