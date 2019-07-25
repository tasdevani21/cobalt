variable "keyvault_secret_name" {
  type        = string
  description = "Name of the keyvault to create"
}

variable "keyvault_secret" {
  type        = string
  description = "SKU of the keyvault to create"
}

variable "keyvault_id" {
  type        = string
  description = "Default resource group name that the network will be created in."
}
