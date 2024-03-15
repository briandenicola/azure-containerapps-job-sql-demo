output "MANAGED_IDENTITY_NAME" {
    value = azurerm_user_assigned_identity.aca_identity.name
    sensitive = false
}