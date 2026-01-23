resource "azurerm_ai_services" "foundry" {
  name                = "aif-aid-${var.environment}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "S0"

  custom_subdomain_name = "aif-aid-${var.environment}-01"

  public_network_access = "Enabled"
  network_acls {
    default_action = "Allow"
    ip_rules       = []
  }

  identity {
    type = "SystemAssigned"
  }

  tags = module.tags.keyvalues
}

resource "azapi_resource_action" "ai_foundry_project_management" {
  type        = "Microsoft.CognitiveServices/accounts@2025-04-01-preview"
  resource_id = azurerm_ai_services.foundry.id
  method      = "PATCH"

  body = {
    properties = {
      allowProjectManagement = true
    }
  }

}

resource "azapi_resource" "ai_foundry_project" {
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name      = "fproj-aid-${var.environment}-01"
  parent_id = azurerm_ai_services.foundry.id
  location  = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      displayName = "AI Foundry Default Project"
      description = "Default AI Foundry project for ${var.environment}"
    }
  }

  depends_on = [
    azapi_resource_action.ai_foundry_project_management
  ]

  tags = module.tags.keyvalues
}

resource "azurerm_private_endpoint" "ai_foundry_pe" {
  name                = "pe-aif-aid-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-aif-aid-${var.environment}-01"
    private_connection_resource_id = azurerm_ai_services.foundry.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name = "pdz-aif-aid-${var.environment}-01"
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.ai_services.id
    ]
  }

  custom_network_interface_name = "nic-pe-aif-aid-${var.environment}-01"

  depends_on = [azurerm_ai_services.foundry]
}