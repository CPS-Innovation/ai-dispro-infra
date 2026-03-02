resource "azurerm_storage_account" "fadependency-sa" {
  name                     = "stfadepaidshrd${var.subscription}01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = module.tags.keyvalues
}

resource "azurerm_private_endpoint" "fadependency-sa-blob-pe" {
  name                = "pe-sa-blob-aidfadep-${var.subscription}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet_id = lookup(
    { for s in azurerm_virtual_network.vnet.subnet : s.name => s },
    "snet-pe-prd-01"
  ).id

  tags = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-sa-blob-aidfadep-${var.subscription}-01"
    private_connection_resource_id = azurerm_storage_account.fadependency-sa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name = "pdz-sa-blob-aidfadep-${var.subscription}-01"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.storage_blob.id
    ]
  }

  custom_network_interface_name = "nic-pe-sa-blob-aidfadep-${var.subscription}-01"

  depends_on = [azurerm_storage_account.fadependency-sa]
}


resource "azurerm_service_plan" "shared-asp" {
  name                = "asp-aid-shrd-${var.subscription}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "EP1"
  tags                = module.tags.keyvalues
}