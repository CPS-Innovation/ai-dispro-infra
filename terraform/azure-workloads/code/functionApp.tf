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

    ###### Azure AI Settings ######

    AZURE_AI_FOUNDRY_API_VERSION     = "2025-03-01-preview"
    AZURE_AI_FOUNDRY_DEPLOYMENT_NAME = "gpt-4o"
    AZURE_AI_FOUNDRY_ENDPOINT        = "https://aif-aid-${var.environment}-01.cognitiveservices.azure.com"
    AZURE_AI_FOUNDRY_PROJECT         = "aif-dispro-dev"

    ###### Doc Intelligence Settings ######

    AZURE_DOC_INTELLIGENCE_API_VERSION = "2024-11-30"
    AZURE_DOC_INTELLIGENCE_ENDPOINT    = "https://di-aid-${var.environment}-01.cognitiveservices.azure.com/"

    ###### Storage Settings ######

    AZURE_BLOB_ACCOUNT_NAME = "staidds${var.environment}01"

    BLOB_CONTAINER_NAME_PROCESSED = "processedq4"
    BLOB_CONTAINER_NAME_SECTION   = "sectionq4"
    BLOB_CONTAINER_NAME_SOURCE    = "sourceq4"

    TABLE_NAME_ANALYSISJOBS     = "analysisjobs_q4"
    TABLE_NAME_ANALYSISRESULTS  = "analysisresults_q4"
    TABLE_NAME_CASES            = "cases_q4"
    TABLE_NAME_CHARGES          = "charges_q4"
    TABLE_NAME_DEFENDANTS       = "defendants_q4"
    TABLE_NAME_DOCUMENTS        = "documents_q4"
    TABLE_NAME_EVENTS           = "events_q4"
    TABLE_NAME_EXPERIMENTS      = "experiments_q4"
    TABLE_NAME_OFFENCES         = "offences_q4"
    TABLE_NAME_PROMPT_TEMPLATES = "prompt_templates_q4"
    TABLE_NAME_SECTIONS         = "sections_q4"
    TABLE_NAME_VERSIONS         = "versions_q4"

    ###### Key Vault Settings ######

    AZURE_KEY_VAULT_URI = "https://kv-aid-${var.subscription}-01.vault.azure.net/"

    ###### CMS/CIN Settings ######

    CMS_API_KEY_AZURE_KEY_VAULT_SECRET_NAME  = "aid-cms-api-key"
    CMS_USERNAME_AZURE_KEY_VAULT_SECRET_NAME = "aid-cms-username"
    CMS_PASSWORD_AZURE_KEY_VAULT_SECRET_NAME = "aid-cms-password"
    CMS_ENDPOINT                             = "https://fa-wm-app-ddei-${var.environment}.azurewebsites.net/api"

    ###### Database Settings ######

    POSTGRESQL_DATABASE_NAME = "ai_dispro_db"
    POSTGRESQL_HOST          = "psql-aid-${var.environment}-01.postgres.database.azure.com"
    POSTGRESQL_PORT          = "5432"
    POSTGRESQL_SCHEMA        = "ai_dispro_schema"
    POSTGRESQL_USERNAME      = "fa-aid-${var.environment}-01"


    ###### Standard App Settings ######

    APPINSIGHTS_INSTRUMENTATIONKEY           = azurerm_application_insights.aid_ai.instrumentation_key
    AzureWebJobsStorage                      = data.azurerm_storage_account.fadependency_sa.primary_connection_string
    BUILD_FLAGS                              = "UseExpressBuild"
    ENABLE_ORYX_BUILD                        = "true"
    FUNCTIONS_EXTENSION_VERSION              = "~4"
    FUNCTIONS_WORKER_RUNTIME                 = "python"
    SCM_DO_BUILD_DURING_DEPLOYMENT           = "1"
    WEBSITE_CONTENTSHARE                     = "fa-co-dispro-dev-01aa99"
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = data.azurerm_storage_account.fadependency_sa.primary_connection_string
    XDG_CACHE_HOME                           = "/tmp/.cache"

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
  subnet_id           = data.azurerm_subnet.pe_subnet.id
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