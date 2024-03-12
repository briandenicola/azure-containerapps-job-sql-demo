resource "azurerm_role_assignment" "acr_pushrole_node" {
  scope                            = azurerm_container_registry.this.id
  role_definition_name             = "AcrPush"
  principal_id                     = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = true
}