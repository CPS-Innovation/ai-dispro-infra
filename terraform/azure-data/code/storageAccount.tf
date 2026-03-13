resource "azurerm_storage_account" "aidds_sa" {
  name                     = "staidds${var.environment}01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = module.tags.keyvalues
}

resource "azurerm_storage_container" "source" {
  name                  = "source"
  storage_account_id    = azurerm_storage_account.aidds_sa.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "processed" {
  name                  = "processed"
  storage_account_id    = azurerm_storage_account.aidds_sa.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "section" {
  name                  = "section"
  storage_account_id    = azurerm_storage_account.aidds_sa.id
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "aidds_sa_blob_pe" {
  name                = "pe-sa-blob-aidds-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-sa-blob-aidds-${var.environment}-01"
    private_connection_resource_id = azurerm_storage_account.aidds_sa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name = "pdz-sa-blob-aidds-${var.environment}-01"
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.blob.id
    ]
  }

  custom_network_interface_name = "nic-pe-sa-blob-aidds-${var.environment}-01"

  depends_on = [azurerm_storage_account.aidds_sa]
}

resource "azurerm_storage_management_policy" "aidds_lifecycle" {
  storage_account_id = azurerm_storage_account.aidds_sa.id

  rule {
    name    = "delete-after-31-days"
    enabled = true

    filters {
      blob_types = ["blockBlob", "appendBlob"]
    }

    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = 31
      }

      snapshot {
        delete_after_days_since_creation_greater_than = 31
      }

      version {
        delete_after_days_since_creation = 31
      }
    }
  }
}