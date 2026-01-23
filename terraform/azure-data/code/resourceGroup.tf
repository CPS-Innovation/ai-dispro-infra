resource "azurerm_resource_group" "rg" {
  name     = "rg-aid-data-${var.environment}-01"
  location = var.location
  tags     = module.tags.keyvalues
}