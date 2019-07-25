module "azure-provider" {
  source = "../provider"
}

data "azurerm_client_config" "secret" {
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "${var.keyvault_secret_name}"
  value        = "${var.keyvault_secret}"
  key_vault_id = "${var.keyvault_id}"
}

