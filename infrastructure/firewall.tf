resource "azurerm_public_ip" "firewall" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "${local.fw_name}-pip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "this" {
  count               = var.deploy_firewall ? 1 : 0
  name                = local.fw_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  firewall_policy_id  = azurerm_firewall_policy.this[0].id
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"

  ip_configuration {
    name                 = "confiugration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
}

resource "azurerm_firewall_policy" "this" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "${local.fw_name}-rules"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  count              = var.deploy_firewall ? 1 : 0
  name               = "${local.fw_name}-rules-collections"
  firewall_policy_id = azurerm_firewall_policy.this[0].id
  priority           = 500

  application_rule_collection {
    name     = "default_rules_collection"
    priority = 500
    action   = "Allow"
    rule {
      name = "docker"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = [
        "*"
      ]
      destination_fqdns = [
        "production.cloudflare.docker.com",
        "hub.docker.com",
        "*.docker.io",
        "download.docker.com"
      ]
    }
    rule {
      name = "azure-management"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = [
        "*"
      ]
      destination_fqdns = [
        "management.microsoft.com",
        "login.microsoftonline.com",
        "login.windows.net",
        "sts.windows.net"
      ]
    }
  }
}
