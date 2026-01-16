resource "azurerm_storage_account" "aidds_sa" {
  name                     = "staidds${var.environment}01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = module.tags.keyvalues
}

resource "azurerm_storage_container" "corpus" {
  name                  = "corpus"
  storage_account_name  = azurerm_storage_account.aidds_sa.name
  container_access_type = "private"
}