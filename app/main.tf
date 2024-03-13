
locals {
  location              = data.azurerm_resource_group.this.location
  resource_name         = var.app_name
  
  
  acr_name              = "${replace(local.resource_name, "-", "")}acr"
  acr_fqdn              = "${local.acr_name}.azurecr.io"
  workload_profile_name = "Consumption"

  aca_name              = "${local.resource_name}-env"
  app_name              = "${local.resource_name}-sqljob"
  app_image             = "${local.acr_fqdn}/sql-job:${var.commit}"
  
  sql_name              = "${local.resource_name}-sql"
  sql_fdqn              = "${local.sql_name}.database.windows.net"
  db_name               = "todo"
  conn_str              = "Data Source=tcp:${local.sql_fdqn};Initial Catalog=${local.db_name};User ID=${local.client_id};Authentication=Active Directory Managed Identity;Encrypt=True;Trust Server Certificate=False;"

  utils_image           = "bjd145/utils:3.15"
}
