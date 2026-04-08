data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

resource "random_password" "password" {
  length  = 25
  special = true
}

resource "random_integer" "vnet_cidr" {
  min = 10
  max = 250
}

locals {
  location              = var.region
  resource_name         = var.app_name
  fw_name               = "${local.resource_name}-fw"
  virtual_network_name  = "${local.resource_name}-network"
  route_table_name      = "${local.resource_name}-routetable"
}

