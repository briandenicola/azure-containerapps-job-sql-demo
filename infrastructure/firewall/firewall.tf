resource "azurerm_public_ip" "firewall" {
  name                = "${local.fw_name}-pip"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "this" {
  name                = local.fw_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  firewall_policy_id  = azurerm_firewall_policy.this.id
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"

  ip_configuration {
    name                 = "confiugration"
    subnet_id            = data.azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_firewall_policy" "this" {
  name                = "${local.fw_name}-rules"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "${local.fw_name}-rules-collections"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 500

  application_rule_collection {
    name     = "default_rules_collection"
    priority = 500
    action   = "Allow"
    #
    #Required for KEDA/Dapr integrations
    # rule {
    #   name = "microsoft-container-registry"
    #   protocols {
    #     type = "Https"
    #     port = 443
    #   }
    #   source_addresses = [
    #     "*"
    #   ]
    #   destination_fqdns = [
    #     "mcr.microsoft.com",
    #     "*.data.mcr.microsoft.com",
    #     "*.blob.core.windows.net"
    #   ]
    # }
    #

    # Allows access to bjd145/utils container
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

    # Allows access to github (optional)
    rule {
      name = "github"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = [
        "*"
      ]
      destination_fqdns = [
        "github.com",
        "raw.githubusercontent.com"
      ]
    }

    # Required for Azure AD and Azure Management
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
        "*.identity.azure.net",
        "management.microsoft.com",
        "login.microsoftonline.com",
        "*.login.microsoftonline.com",
        "login.windows.net",
        "login.microsoft.com",
        "sts.windows.net"
      ]
    }
  }
}
