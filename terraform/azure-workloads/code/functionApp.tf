resource "azurerm_linux_function_app" "aid_func" {
  name                          = "fa-aid-${var.environment}-01"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  service_plan_id               = data.azurerm_app_service_plan.shared_asp.id
  storage_account_name          = data.azurerm_storage_account.fadependency_sa.name
  storage_account_access_key    = data.azurerm_storage_account.fadependency_sa.primary_access_key
  virtual_network_subnet_id     = data.azurerm_subnet.asp_shrd_vnetint_subnet.id
  public_network_access_enabled = false
  https_only                    = true
  tags                          = module.tags.keyvalues

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.aid_ai.instrumentation_key

    AZURE_AI_FOUNDRY_API_VERSION     = "2025-03-01-preview"
    AZURE_AI_FOUNDRY_DEPLOYMENT_NAME = "gpt-4o"
    AZURE_AI_FOUNDRY_ENDPOINT        = "https://aif-dispro-dev.cognitiveservices.azure.com/"
    AZURE_AI_FOUNDRY_PROJECT         = "aif-dispro-dev"

    AZURE_BLOB_ACCOUNT_NAME            = "stdisprodev001"
    AZURE_BLOB_CONTAINER_NAME_ANALYSIS = "processedtst"
    AZURE_BLOB_CONTAINER_NAME_DOCUMENT = "processedtst"
    AZURE_BLOB_CONTAINER_NAME_SECTION  = "processedtst"
    AZURE_BLOB_CONTAINER_NAME_SOURCE   = "corpus"
    AZURE_BLOB_CONTAINER_NAME_TEST     = "processedtst"

    AZURE_DOC_INTELLIGENCE_API_VERSION = "2024-11-30"
    AZURE_DOC_INTELLIGENCE_ENDPOINT    = "https://di-dispro-dev.cognitiveservices.azure.com/"

    AZURE_KEY_VAULT_CMS_API_KEY_NAME              = "cms-key-dev"
    AZURE_KEY_VAULT_CMS_PASSWORD_NAME             = "cms-user-pass-dev"
    AZURE_KEY_VAULT_CMS_USER_NAME                 = "cms-user-name-dev"
    AZURE_KEY_VAULT_DOC_INTELLIGENCE_API_KEY_NAME = "DocIntelApiKey"
    AZURE_KEY_VAULT_POSTGRESQL_PASSWORD_NAME      = "psql-password-dev"
    AZURE_KEY_VAULT_URI                           = "https://kv-dispro-dev-1.vault.azure.net/"

    AZURE_TABLE_ACCOUNT_NAME = "stdisprodev001"

    AzureWebJobsStorage = ""

    BUILD_FLAGS = "UseExpressBuild"

    CMS_ENDPOINT = "https://fa-wm-app-ddei-dev.azurewebsites.net/api"

    ENABLE_ORYX_BUILD = "true"
    ENVIRONMENT       = "tst"

    FUNCTIONS_EXTENSION_VERSION = "~4"
    FUNCTIONS_WORKER_RUNTIME    = "python"

    POSTGRESQL_DATABASE_NAME = "postgres"
    POSTGRESQL_HOST          = "10.7.175.47"
    POSTGRESQL_PORT          = "5432"
    POSTGRESQL_USER          = "postgres"

    SCM_DO_BUILD_DURING_DEPLOYMENT = "1"

    TABLE_NAME_ANALYSIS = "analysestst"
    TABLE_NAME_DOCUMENT = "documentstst"
    TABLE_NAME_PROMPT   = "promptsq3"
    TABLE_NAME_SECTION  = "sectionstst"
    TABLE_NAME_STATUS   = "statustst"
    TABLE_NAME_TEST     = "test"

    WEBSITE_CONTENTSHARE                     = "fa-co-dispro-dev-01aa99"

    XDG_CACHE_HOME = "/tmp/.cache"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }

    cors {
      allowed_origins = [
        "https://portal.azure.com",
      ]
      support_credentials = false
    }

    scm_use_main_ip_restriction = true
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_private_endpoint" "func_pe" {
  name                = "pe-fa-aid-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.asp_shrd_pe_subnet.id
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-fa-aid-${var.environment}-01"
    private_connection_resource_id = azurerm_linux_function_app.aid_func.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name = "pdz-fa-${var.environment}-01"
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.app.id
    ]
  }

  custom_network_interface_name = "nic-pe-fa-aid-${var.environment}-01"

  depends_on = [azurerm_linux_function_app.aid_func]
}