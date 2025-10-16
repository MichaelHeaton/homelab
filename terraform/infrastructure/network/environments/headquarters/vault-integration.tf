# Vault Integration for UniFi Network Management
# This file configures Terraform to use HashiCorp Vault for sensitive data

# Vault Provider Configuration
provider "vault" {
  address = "https://vault.specterrealm.com"
  # Vault token will be read from VAULT_TOKEN environment variable
}

# Data source to read UniFi controller credentials from Vault
data "vault_kv_secret_v2" "unifi_credentials" {
  mount = "homelab"
  name  = "controllers/headquarters/api-credentials"
}

# Data source to read WLAN passwords from Vault
data "vault_kv_secret_v2" "wlan_passwords" {
  mount = "homelab"
  name  = "controllers/headquarters/wlan-passwords"
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
