# Shared Vault Integration for UniFi Network Management
# This file provides Vault integration that can be used across all environments

# Note: Vault provider configuration is in the main terraform.tf

# Data source to read UniFi controller credentials from Vault
# This will be customized per environment
data "vault_kv_secret_v2" "unifi_credentials" {
  mount = "homelab"
  name  = "infrastructure/unifi/${var.site_name}/api-credentials"
}

# Data source to read WLAN passwords from Vault
# This will be customized per environment
data "vault_kv_secret_v2" "wlan_passwords" {
  mount = "homelab"
  name  = "infrastructure/unifi/${var.site_name}/wlan-passwords"
}

# Local values for UniFi controller configuration
locals {
  unifi_username = data.vault_kv_secret_v2.unifi_credentials.data["unifi_username"]
  unifi_password = data.vault_kv_secret_v2.unifi_credentials.data["unifi_password"]
  unifi_api_key  = data.vault_kv_secret_v2.unifi_credentials.data["unifi_api_key"]

  # WLAN passwords from Vault
  wlan_skynet_global_password = data.vault_kv_secret_v2.wlan_passwords.data["wlan_skynet_global_password"]
  wlan_skynet_password        = data.vault_kv_secret_v2.wlan_passwords.data["wlan_skynet_password"]
  wlan_skynet_iot_password    = data.vault_kv_secret_v2.wlan_passwords.data["wlan_skynet_iot_password"]
  wlan_wifightclub_password   = data.vault_kv_secret_v2.wlan_passwords.data["wlan_wifightclub_password"]
  wlan_bigbrothers_password   = data.vault_kv_secret_v2.wlan_passwords.data["wlan_bigbrothers_password"]
}

# Outputs for use by calling modules
output "unifi_api_key" {
  description = "UniFi API key from Vault"
  value       = local.unifi_api_key
  sensitive   = true
}

output "unifi_username" {
  description = "UniFi username from Vault"
  value       = local.unifi_username
  sensitive   = true
}

output "unifi_password" {
  description = "UniFi password from Vault"
  value       = local.unifi_password
  sensitive   = true
}

output "wlan_passwords" {
  description = "WLAN passwords from Vault"
  value = {
    skynet_global = local.wlan_skynet_global_password
    skynet        = local.wlan_skynet_password
    skynet_iot    = local.wlan_skynet_iot_password
    wifightclub   = local.wlan_wifightclub_password
    bigbrothers   = local.wlan_bigbrothers_password
  }
  sensitive = true
}
