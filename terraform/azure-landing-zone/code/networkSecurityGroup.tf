resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-aid-${var.subscription}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.tags.keyvalues
}

resource "azurerm_monitor_diagnostic_setting" "nsg_diagnostic" {
  name                       = "diag-nsg-aid-${var.subscription}-01"
  target_resource_id         = azurerm_network_security_group.nsg.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }

}