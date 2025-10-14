# Policy for Terraform UniFi management
# Only allows reading/writing UniFi secrets

# Allow reading UniFi WLAN passwords
path "unifi/data/wlan-passwords" {
  capabilities = ["read"]
}

# Allow writing UniFi WLAN passwords (for updates)
path "unifi/data/wlan-passwords" {
  capabilities = ["create", "update"]
}

# Allow listing secrets
path "unifi/metadata/wlan-passwords" {
  capabilities = ["read", "list"]
}

# Allow managing KV secrets engine
path "unifi/*" {
  capabilities = ["read", "list"]
}

