resource "azurerm_ai_services" "foundry" {
  name                = "aif-aid-${var.environment}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "S0"
}

resource "azurerm_ai_foundry_project" "foundry_project" {
  name               = "fproj-aid-${var.environment}-01"
  location           = azurerm_resource_group.rg.location
  ai_services_hub_id = azurerm_ai_foundry.foundry.id
}