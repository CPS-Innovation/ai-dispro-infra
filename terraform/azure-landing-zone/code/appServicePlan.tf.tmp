resource "azurerm_storage_account" "fadependency-sa" {
  name                     = "stfadepaidshrd${var.subscription}01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = module.tags.keyvalues
}

resource "azurerm_service_plan" "shared-asp" {
  name                = "asp-aid-shrd-${var.subscription}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "EP1"
  tags                = module.tags.keyvalues
}