resource "azurerm_resource_group" "rg" {
  name     = "rg-aidispro-${var.environment}-01"
  location = var.location
}