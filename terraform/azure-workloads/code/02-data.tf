data "azurerm_subnet" "asp_shrd_vnetint_subnet" {
  name                 = "snet-asp-shrd-vnetint-${var.subscription}-01"
  virtual_network_name = "vnet-aid-${var.subscription}-01"
  resource_group_name  = "rg-aid-${var.subscription}-01"
}

data "azurerm_subnet" "asp_shrd_pe_subnet" {
  name                 = "snet-asp-shrd-pe-${var.environment}-01"
  virtual_network_name = "vnet-aid-${var.subscription}-01"
  resource_group_name  = "rg-aid-${var.subscription}-01"
}

data "azurerm_subnet" "nonprod_subnet" {
  name                 = "snet-${var.subscription}-01"
  virtual_network_name = "vnet-aid-${var.subscription}-01"
  resource_group_name  = "rg-aid-${var.subscription}-01"
}


data "azurerm_key_vault" "kv_aid" {
  name                = "kv-aid-${var.subscription}-01"
  resource_group_name = "rg-aid-${var.subscription}-01"
}

output "key_vault_id" {
  description = "The Azure Resource ID of the Key Vault"
  value       = data.azurerm_key_vault.kv_aid.id
}


data "azurerm_log_analytics_workspace" "law" {
  name                = "law-aid-${var.subscription}-01"
  resource_group_name = "rg-aid-${var.subscription}-01"
}

output "log_analytics_workspace_id" {
  value = data.azurerm_log_analytics_workspace.law.id
}


data "azurerm_app_service_plan" "shared_asp" {
  name                = "asp-aid-shrd-${var.subscription}-01"
  resource_group_name = "rg-aid-${var.subscription}-01"
}

output "app_service_plan_id" {
  value = data.azurerm_app_service_plan.shared_asp.id
}



data "azurerm_storage_account" "fadependency_sa" {
  name                = "stfadepaidshrd${var.subscription}01"
  resource_group_name = "rg-aid-${var.subscription}-01"
}

output "storage_account_access_key" {
  value     = data.azurerm_storage_account.fadependency_sa.primary_access_key
  sensitive = true

}

data "azurerm_private_dns_zone" "app" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = "rg-aid-${var.subscription}-01"
}