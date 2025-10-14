# UniFi WLAN Configuration
# This file defines all your existing WLANs using centralized configuration

# Skynet Global Defense Network (Main Family WiFi)
resource "unifi_wlan" "skynet_global_defense" {
  name           = "Skynet Global Defense Network"
  security       = "wpapsk"
  passphrase     = local.wlan_skynet_global_password
  network_id     = unifi_network.family.id
  wlan_band      = "both"
  user_group_id  = "5f9b136a34ef8006578d187f"
  ap_group_ids   = ["5fcb5af8272e4f03936dc514"]
  bss_transition = false
  no2ghz_oui     = false
}

# SkyNet (IoT 5GHz)
resource "unifi_wlan" "skynet" {
  name          = "SkyNet"
  security      = "wpapsk"
  passphrase    = local.wlan_skynet_password
  network_id    = unifi_network.iot.id
  wlan_band     = "5g"
  user_group_id = "5f9b136a34ef8006578d187f"
  ap_group_ids  = ["5fcb5af8272e4f03936dc514"]
}

# SkyNet_IoT (IoT 2.4GHz)
resource "unifi_wlan" "skynet_iot" {
  name          = "SkyNet_IoT"
  security      = "wpapsk"
  passphrase    = local.wlan_skynet_iot_password
  network_id    = unifi_network.iot.id
  wlan_band     = "2g"
  user_group_id = "5f9b136a34ef8006578d187f"
  ap_group_ids  = ["5fcb5af8272e4f03936dc514"]
  no2ghz_oui    = false
}

# WiFightClub (IoT WPA3)
resource "unifi_wlan" "wifightclub" {
  name          = "WiFightClub"
  security      = "wpapsk"
  passphrase    = local.wlan_wifightclub_password
  network_id    = unifi_network.iot.id
  wlan_band     = "both"
  user_group_id = "5f9b136a34ef8006578d187f"
  ap_group_ids  = ["5fcb5af8272e4f03936dc514"]
  pmf_mode      = "required"
  wpa3_support  = true
}

# BigBrothersWiFi (IoT 2.4GHz)
resource "unifi_wlan" "bigbrotherswifi" {
  name          = "BigBrothersWiFi"
  security      = "wpapsk"
  passphrase    = local.wlan_bigbrothers_password
  network_id    = unifi_network.iot.id
  wlan_band     = "2g"
  user_group_id = "5f9b136a34ef8006578d187f"
  ap_group_ids  = ["5fcb5af8272e4f03936dc514"]
  l2_isolation  = true
  no2ghz_oui    = false
}
