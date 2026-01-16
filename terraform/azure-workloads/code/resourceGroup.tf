resource "azurerm_resource_group" "rg" {
  name     = "rg-aid-app-workloads-${var.environment}-01"
  location = var.location
  tags     = module.tags.keyvalues
}
