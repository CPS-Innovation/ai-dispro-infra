resource "azurerm_storage_account" "aiddf_sa" {
  name                     = "staiddf${var.environment}01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = module.tags.keyvalues
}

resource "azurerm_private_endpoint" "aiddf_sa_blob_pe" {
  name                = "pe-sa-blob-aiddf-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-sa-blob-aiddf-${var.environment}-01"
    private_connection_resource_id = azurerm_storage_account.aiddf_sa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name = "pdz-sa-blob-aiddf-${var.environment}-01"
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.blob.id
    ]
  }

  custom_network_interface_name = "nic-pe-sa-blob-aiddf-${var.environment}-01"

  depends_on = [azurerm_storage_account.aiddf_sa]
}

resource "azurerm_private_endpoint" "aiddf_sa_table_pe" {
  name                = "pe-sa-table-aiddf-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-sa-table-aiddf-${var.environment}-01"
    private_connection_resource_id = azurerm_storage_account.aiddf_sa.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name = "pdz-sa-table-aiddf-${var.environment}-01"
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.table.id
    ]
  }

  custom_network_interface_name = "nic-pe-sa-table-aiddf-${var.environment}-01"

  depends_on = [azurerm_storage_account.aiddf_sa]
}

resource "azurerm_private_endpoint" "aiddf_sa_queue_pe" {
  name                = "pe-sa-queue-aiddf-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-sa-queue-aiddf-${var.environment}-01"
    private_connection_resource_id = azurerm_storage_account.aiddf_sa.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name = "pdz-sa-queue-aiddf-${var.environment}-01"
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.queue.id
    ]
  }

  custom_network_interface_name = "nic-pe-sa-queue-aiddf-${var.environment}-01"

  depends_on = [azurerm_storage_account.aiddf_sa]
}
