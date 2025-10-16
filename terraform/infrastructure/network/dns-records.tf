# UniFi Static DNS Records
# These records were successfully imported from the UniFi controller

# CNAME Records
resource "unifi_dns_record" "portainer" {
  name        = "portainer.specterrealm.com"
  record_type = "CNAME"
  value       = "traefik-internal.specterrealm.com"
  port        = 0
}

resource "unifi_dns_record" "whoami" {
  name        = "whoami.SpecterRealm.com"
  record_type = "CNAME"
  value       = "traefik-internal.specterrealm.com"
  port        = 0
}

# Additional DNS Records from Backup Analysis (Successfully Imported)

resource "unifi_dns_record" "gpu01" {
  name        = "gpu01.specterrealm.com"
  record_type = "A"
  value       = "172.16.15.10"
  port        = 0
}

resource "unifi_dns_record" "nuc01" {
  name        = "nuc01.specterrealm.com"
  record_type = "A"
  value       = "172.16.15.11"
  port        = 0
}

resource "unifi_dns_record" "nuc02" {
  name        = "nuc02.specterrealm.com"
  record_type = "A"
  value       = "172.16.15.12"
  port        = 0
}

resource "unifi_dns_record" "nuc01_cl" {
  name        = "nuc01-cl.specterrealm.com"
  record_type = "A"
  value       = "172.16.12.11"
  port        = 0
}

resource "unifi_dns_record" "nuc02_cl" {
  name        = "nuc02-cl.specterrealm.com"
  record_type = "A"
  value       = "172.16.12.12"
  port        = 0
}

resource "unifi_dns_record" "gpu01_cl" {
  name        = "gpu01-cl.specterrealm.com"
  record_type = "A"
  value       = "172.16.12.10"
  port        = 0
}

resource "unifi_dns_record" "traefik" {
  name        = "traefik.SpecterRealm.com"
  record_type = "A"
  value       = "172.16.0.9"
  port        = 0
}

resource "unifi_dns_record" "portainer_mgmt" {
  name        = "Portainer-Mgmt.SpecterRealm.com"
  record_type = "A"
  value       = "172.16.15.5"
  port        = 0
}

# Note: jenkins_mgmt and jenkins_agent_01 were not found in live controller
