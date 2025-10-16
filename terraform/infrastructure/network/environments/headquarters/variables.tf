# FW-U36 Environment Variables

# Site Configuration
variable "site_name" {
  description = "UniFi site name (used for Vault paths and resource naming)"
  type        = string
  default     = "headquarters"
}

variable "unifi_api_url" {
  description = "UniFi controller API URL"
  type        = string
  default     = "https://unifi.mgmt.specterrealm.com"
}

variable "unifi_site" {
  description = "UniFi controller site"
  type        = string
  default     = "default"
}

variable "unifi_allow_insecure" {
  description = "Allow insecure connections to UniFi controller"
  type        = bool
  default     = true
}

# Network Configuration
variable "dns_servers" {
  description = "DNS servers for all VLANs"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "dhcp_lease_time" {
  description = "DHCP lease time in seconds"
  type        = number
  default     = 86400 # 24 hours
}

# VLAN Configuration
variable "enable_dhcp" {
  description = "Enable DHCP on all VLANs"
  type        = bool
  default     = true
}

variable "vlan_purpose" {
  description = "Purpose for all VLANs"
  type        = string
  default     = "corporate"
}

# Security Configuration
variable "enable_firewall" {
  description = "Enable firewall rules"
  type        = bool
  default     = true
}

variable "enable_guest_isolation" {
  description = "Enable guest network isolation"
  type        = bool
  default     = true
}

# Monitoring Configuration
variable "enable_monitoring" {
  description = "Enable network monitoring"
  type        = bool
  default     = true
}

variable "monitoring_retention" {
  description = "Monitoring data retention in days"
  type        = number
  default     = 30
}
