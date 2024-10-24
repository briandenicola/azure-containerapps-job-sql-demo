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
  resource_name         = "${random_pet.this.id}-${random_id.this.dec}"
  rg_name               = "${local.resource_name}_rg"
  aca_name              = "${local.resource_name}-env"
  sql_name              = "${local.resource_name}-sql"
  fw_name               = "${local.resource_name}-fw"
  acr_name              = "${replace(local.resource_name, "-", "")}acr"
  workload_profile_name = "Consumption"
  vnet_cidr             = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  pe_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 1)
  compute_subnet_cidir  = cidrsubnet(local.vnet_cidr, 8, 2)
  nodes_subnet_cidir    = cidrsubnet(local.vnet_cidr, 4, 2)
  fw_subnet_cidir       = cidrsubnet(local.vnet_cidr, 8, 3)
  tags                  = var.tags
}