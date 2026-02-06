resource "azurerm_key_vault" "kv" {
  name                          = "kv-aid-${var.subscription}-01"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  enabled_for_disk_encryption   = true
  rbac_authorization_enabled    = true
  public_network_access_enabled = false
  tags                          = module.tags.keyvalues
}

resource "azurerm_private_endpoint" "kv_pe" {
  name                = "pe-kv-aid-${var.subscription}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = local.subnet_ids["snet-${var.subscription}-01"]
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-kv-aid-${var.subscription}-01"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "pdz-kv-${var.subscription}-01"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.keyvault.id
    ]
  }
}