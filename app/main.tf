
locals {
  location              = data.azurerm_resource_group.this.location
  resource_name         = var.app_name
  workload_profile_name = "Consumption"
  acr_name              = "${replace(local.resource_name,"-","")}acr"
  acr_full_name         = "${local.acr_name}.azurecr.io"
  aca_name              = "${local.resource_name}-env"
  app_name              = "${local.resource_name}-job"
  sql_name              = "${local.resource_name}-job"
  db_name               = "todo"
  apps_image            = "${local.acr_full_name}/sql-job:${var.commit}"
  utils_image           = "bjd145/utils:3.15"
}