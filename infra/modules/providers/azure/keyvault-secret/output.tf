output "keyvault_secret_id" {
  description = "The id of the Keyvault secret"
  value       = azurerm_key_vault_secret.secret.id
}

output "keyvault_secret_version" {
  description = "The version of the keyvault secret"
  value       = azurerm_key_vault_secret.secret.version
}
