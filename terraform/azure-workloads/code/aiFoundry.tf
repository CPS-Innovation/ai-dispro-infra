resource "azurerm_ai_foundry" "foundry" {
  name                = "aif-aid-${var.environment}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  storage_account_id  = azurerm_storage_account.aidds_sa.id
  key_vault_id        = data.azurerm_key_vault.kv_aid.id

  identity {
    type = "SystemAssigned"
  }
}

/*

resource "azurerm_ai_foundry_project" "foundry_project" {
  name               = "fproj-aid-${var.environment}-01"
  location           = azurerm_resource_group.rg.location
  ai_services_hub_id = azurerm_ai_foundry.foundry.id
}

*/