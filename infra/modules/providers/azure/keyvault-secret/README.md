# keyvault-secret

A terraform module to provide Key Vaults secrets for existing Key Vaults in Azure with the following characteristics:

- Secrets have a name that identifies them in the URL/ID
- Secrets have a secret value that gets encrypted and protected by the key vault

## Usage

Key Vault secret usage example:

```hcl

module "keyvault-secret" {
  source               = "../../modules/providers/azure/keyvault-secret"
  keyvault_secret_name = "${local.kv_secret_name}"
  keyvault_secret      = "${local.kv_secret}"
  keyvault_id          = "${local.kv_id}"
}
```

## Variables Reference

The following variables are used:

- `keyvault_secret_name`: The id of the Key Vault.
- `keyvault_secret`: The uri of the Key Vault.
- `keyvault_id`: The id of the Key Vault.

## Attributes Reference

The following attributes are exported:

- `keyvault_secret_id`: The id of the Key Vault secret.
- `keyvault_secret_version`: The version of the Key Vault secret.
