resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = local.location

  tags = {
    Application = local.tags
    Components  = "Container Apps; Azure SQL; Azure Container Registry; Azure Firewall"
    DeployedOn  = timestamp()
  }
}