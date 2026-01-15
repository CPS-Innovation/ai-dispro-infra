resource "azurerm_postgresql_flexible_server" "psql" {
  name                          = "psql-aid-${var.environment}-01"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  version                       = "16"
  zone                          = "1"
  sku_name                      = var.sku
  storage_mb                    = 131072
  storage_tier                  = "P10"
  public_network_access_enabled = false
  backup_retention_days         = 30

  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled         = false
  }

  dynamic "high_availability" {
    for_each = var.environment == "prd" ? [1] : []
    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = "1" # Ensure this is different from the primary zone
    }
  }

}

resource "azurerm_private_endpoint" "psql_private_endpoint" {
  name                = "pep-psql-aid-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.psql_subnet.id

  private_service_connection {
    name                           = "psc-psql-aid-${var.environment}-01"
    private_connection_resource_id = azurerm_postgresql_flexible_server.psql.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }

  ip_configuration {
    name               = "ipc-psql-aid-${var.environment}-01"
    private_ip_address = var.static_ip
    member_name        = "postgresqlServer"
    subresource_name   = "postgresqlServer"
  }

  private_dns_zone_group {
    name = "pdz-psql-${var.environment}-01"
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.psql.id
    ]
  }

}

resource "azurerm_postgresql_flexible_server_configuration" "psql-dp-enable-uuidossp" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.psql.id
  value     = "UUID-OSSP"
}

resource "azurerm_postgresql_flexible_server_configuration" "psql-dp-enable-connectionthrottling" {
  name      = "connection_throttle.enable"
  server_id = azurerm_postgresql_flexible_server.psql.id
  value     = "on"
}