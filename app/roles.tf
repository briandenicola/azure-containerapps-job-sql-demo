resource "azurerm_role_assignment" "acr_pullrole_node" {
  scope                            = data.azurerm_container_registry.this.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.aca_identity.principal_id
  skip_service_principal_aad_check = true
}