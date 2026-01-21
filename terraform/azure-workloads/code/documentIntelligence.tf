resource "azurerm_cognitive_account" "document_intelligence" {
  name                = "di-aid-${var.environment}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind     = "FormRecognizer"
  sku_name = "S0"

  custom_subdomain_name = "di-aid-${var.environment}-01"

  # Network access
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