resource "azurerm_ai_services" "foundry" {
  name                = "aif-aid-${var.environment}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "S0"
}

resource "azurerm_ai_foundry_project" "project" {
  name                = "fproj-aid-${var.environment}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ai_services_account_id = azurerm_ai_services.foundry.id

  identity {
    type = "SystemAssigned"
  }
}