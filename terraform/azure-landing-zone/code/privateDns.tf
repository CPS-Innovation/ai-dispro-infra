# ----------------------------------------------------------------------------------------------------------------------
# Private DNS Resources for Key Vault

# -----------------------------------------
# Private DNS Zone for Key Vault
# -----------------------------------------
resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.tags.keyvalues
}

# -----------------------------------------
# Link Key Vault DNS Zone to VNET
# -----------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_vnet_link" {
  name                  = "pdz-keyvault-vnet-link-${var.subscription}-01"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = module.tags.keyvalues
}

# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# Private DNS Resources for PostgreSQL

# -----------------------------------------
# Private DNS Zone for PostgreSQL
# -----------------------------------------
resource "azurerm_private_dns_zone" "psql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.tags.keyvalues
}

# -----------------------------------------
# Link PostgreSQL DNS Zone to VNET
# -----------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "psql_link" {
  name                  = "pdz-psql-link-${var.subscription}-01"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.psql.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = module.tags.keyvalues
}

# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# Private DNS Resources for App Services

# -----------------------------------------
# Private DNS Zone for App Services
# -----------------------------------------
resource "azurerm_private_dns_zone" "app" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.tags.keyvalues
}

# -----------------------------------------
# Link DNS Zone to VNET
# -----------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "app_vnet_link" {
  name                  = "pdz-app-vnet-link-${var.subscription}"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.app.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = module.tags.keyvalues
}

# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------
# Private DNS Zone for Storage Blob
# -----------------------------------------
resource "azurerm_private_dns_zone" "storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.tags.keyvalues
}

# -----------------------------------------
# Link Storage Blob DNS Zone to VNET
# -----------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob_vnet_link" {
  name                  = "pdz-storage-blob-vnet-link-${var.subscription}-01"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_blob.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = module.tags.keyvalues
}

# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------
# Private DNS Zone for Storage Table
# -----------------------------------------
resource "azurerm_private_dns_zone" "storage_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.tags.keyvalues
}

# -----------------------------------------
# Link Storage Table DNS Zone to VNET
# -----------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "storage_table_vnet_link" {
  name                  = "pdz-storage-table-vnet-link-${var.subscription}-01"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_table.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = module.tags.keyvalues
}

# ----------------------------------------------------------------------------------------------------------------------