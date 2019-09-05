module "provider" {
  source = "../../modules/providers/azure/provider"
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

locals {
  // sanitize names
  app_id  = replace(trimspace(lower(var.name)), "_", "-")
  region = replace(trimspace(lower(var.resource_group_location)), "_", "-")
  ws_name = replace(trimspace(lower(terraform.workspace)), "_", "-")

  // base name for resources, name constraints documented here: https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
  base_name     = "${local.app_id}-${local.ws_name}"
  base_name_21  = length(local.base_name) < 22 ? local.base_name : "${substr(replace(local.app_id, "-", ""), 0, 10)}-${substr(replace(local.ws_name, "-", ""), 0, 10)}"
  base_name_46  = length(local.base_name) < 47 ? local.base_name : "${substr(replace(local.app_id, "-", ""), 0, 25)}-${substr(replace(local.ws_name, "-", ""), 0, 20)}"
  base_name_60  = length(local.base_name) < 61 ? local.base_name : "${substr(replace(local.app_id, "-", ""), 0, 34)}-${substr(replace(local.ws_name, "-", ""), 0, 25)}"
  base_name_76  = length(local.base_name) < 77 ? local.base_name : "${substr(replace(local.app_id, "-", ""), 0, 45)}-${substr(replace(local.ws_name, "-", ""), 0, 30)}"
  base_name_83  = length(local.base_name) < 84 ? local.base_name : "${substr(replace(local.app_id, "-", ""), 0, 52)}-${substr(replace(local.ws_name, "-", ""), 0, 30)}"

  tenant_id     = data.azurerm_client_config.current.tenant_id

  // Resource names
  admin_rg_name      = "${local.base_name_83}-adm-rg"               // resource group used for admin resources (max 90 chars)
  app_rg_name        = "${local.base_name_83}-app-rg"               // app resource group (max 90 chars)
  admin_rg_lock      = "${local.base_name_83}-adm-rg-delete-lock"   // management lock to prevent deletes
  app_rg_lock        = "${local.base_name_83}-app-rg-delete-lock"   // management lock to prevent deletes
  sp_name            = "${local.base_name}-sp"                      // service plan
  ai_name            = "${local.base_name}-ai"                      // app insights
  kv_name            = "${local.base_name_21}-kv"                   // key vault (max 24 chars)
  acr_name           = "${replace(local.base_name_46, "-", "")}acr" // container registry (max 50 chars, alphanumeric *only*)
  vnet_name          = "${local.base_name_60}-net"                  // virtual network (max 64 chars)
  tm_profile_name    = "${local.base_name_60}-tf"                   // traffic manager profile (max 63 chars)
  tm_endpoint_name   = "${local.region}_${local.app_id}"            // traffic manager endpoint
  tm_dns_name        = "${local.base_name}-dns"                     // traffic manager dns relative name
  appgateway_name    = "${local.base_name_76}-gw"                   // app gateway (max 80 chars)
  public_pip_name    = "${local.base_name_76}-ip"                   // public IP (max 80 chars)
  svc_princ_name     = "${local.base_name}-svc-principal"           // service principal
  acr_svc_princ_name = "${local.base_name}-acr-svc-principal"       // container registry service principal

  // Resolved TF Vars
  ase_sub_id           = var.ase_subscription_id == "" ? data.azurerm_subscription.current.subscription_id : var.ase_subscription_id
  app_sub_id           = var.app_dev_subscription_id == "" ? data.azurerm_subscription.current.subscription_id : var.app_dev_subscription_id
  // id of App Service Environment
  ase_id = "/subscriptions/${local.ase_sub_id}/resourceGroups/${var.ase_resource_group}/providers/Microsoft.Web/hostingEnvironments/${var.ase_name}"

  app_secrets = {
    "app-service-principal-object-id"      = module.app_service_principal_contributor.service_principal_object_id,
    "app-service-principal-application-id" = module.app_service_principal_contributor.service_principal_application_id,
    "app-service-principal-display-name"   = module.app_service_principal_contributor.service_principal_display_name,
    "app-service-principal-password"       = module.app_service_principal_contributor.service_principal_password,
    "container-registry-name"              = module.container_registry.container_registry_name
  }
  acr_secrets = {
    "acr-service-principal-object-id"      = module.acr_service_principal_acrpull.service_principal_object_id,
    "acr-service-principal-application-id" = module.acr_service_principal_acrpull.service_principal_application_id,
    "acr-service-principal-display-name"   = module.acr_service_principal_acrpull.service_principal_display_name
  }
  acr_password = {
    "acr-service-principal-password" = module.acr_service_principal_acrpull.service_principal_password
  }
}
