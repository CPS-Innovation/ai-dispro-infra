resource "azurerm_resource_group" "rg" {
  name     = "rg-aid-${var.subscription}-01"
  location = var.location
  tags     = module.tags.keyvalues
}