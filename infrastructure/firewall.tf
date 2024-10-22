module "firewall" {
  depends_on = [ 
    azurerm_subnet.firewall
  ]
  
  count     = var.deploy_firewall ? 1 : 0
  source    = "./firewall"
  app_name  = local.resource_name
  region    = local.location
  rg_name   = local.rg_name
}
