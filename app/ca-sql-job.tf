locals {
  client_id = azurerm_user_assigned_identity.aca_identity.client_id
} 

resource "azapi_resource" "azurerm_container_app_jobs" {
  depends_on = [ 
    azurerm_role_assignment.acr_pullrole_node
  ]
  
  name      = local.app_name
  type      = "Microsoft.App/jobs@2023-05-01"
  parent_id = data.azurerm_resource_group.this.id
  location  = data.azurerm_resource_group.this.location

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aca_identity.id
    ]
  }

  body = jsonencode({
    properties = {

      environmentId = data.azurerm_container_app_environment.this.id
      workloadProfileName  = local.workload_profile_name

      configuration = {
        triggerType = "manual"
        replicaTimeout = 300
        manualTriggerConfig = {
          parallelism            = 1
          replicaCompletionCount = 1
        }
        registries  = [{
          server    = local.acr_fqdn
          identity  = azurerm_user_assigned_identity.aca_identity.id
        }]
      }

      template = {
        containers = [{
          name  = local.app_name
          image = local.app_image
          resources = {
            cpu    = 1
            memory = "2Gi"
          }
          env = [{
            name  = "CONN_STR",
            value = local.conn_str
          },
          {
            name  = "DB_HOST",
            value = local.sql_fdqn
          }],
        }]
      }
    }
  })
}