resource "azurerm_cognitive_account" "document_intelligence" {
  name                  = "di-aid-${var.environment}-01"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  kind                  = "FormRecognizer"
  sku_name              = "S0"
  custom_subdomain_name = "di-aid-${var.environment}-01"
  tags                  = module.tags.keyvalues

  public_network_access_enabled = false

  network_acls {
    default_action = "Allow"
    ip_rules       = []
  }

  local_auth_enabled = false

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_private_endpoint" "document_intelligence_pe" {
  name                = "pe-di-aid-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-di-aid-${var.environment}-01"
    private_connection_resource_id = azurerm_cognitive_account.document_intelligence.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name = "pdz-di-aid-${var.environment}-01"
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.ai_services.id
    ]
  }

  custom_network_interface_name = "nic-pe-di-aid-${var.environment}-01"

  depends_on = [azurerm_cognitive_account.document_intelligence]
}