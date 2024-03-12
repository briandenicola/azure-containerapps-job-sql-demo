data "azurerm_resource_group" "this" {
  name     = "${var.app_name}_rg"
}

data "azurerm_container_app_environment" "this" {
  name                = local.aca_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_container_registry" "this" {
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
