data "nsxt_policy_tier0_gateway" "tier0_gw_gateway" {
  display_name = var.nsx_t0gw
}

data "nsxt_policy_gateway_locale_service" "t0gw" {
  gateway_path = data.nsxt_policy_tier0_gateway.tier0_gw_gateway.path
}

resource "nsxt_policy_ipsec_vpn_service" "ipsec" {
  display_name  = "ipsec-vpn-service1"
  description   = "Terraform provisioned IPSec VPN service"
  gateway_path  = data.nsxt_policy_tier0_gateway.tier0_gw_gateway.path
  ike_log_level = "INFO"
}

resource "nsxt_policy_ipsec_vpn_local_endpoint" "local-ep" {
  display_name  = "local-ep"
  service_path  = nsxt_policy_ipsec_vpn_service.ipsec.path
  description   = "Terraform provisioned IPSec VPN Local Endpoint"
  local_address = var.local_address
  local_id      = "local-ep"
}

resource "nsxt_policy_ipsec_vpn_session" "ipsec-aws" {
  display_name               = "ipsec-aws"
  description                = "Terraform-provisioned IPsec Route-Based VPN"
  local_endpoint_path        = nsxt_policy_ipsec_vpn_local_endpoint.local-ep.path
  dpd_profile_path           = "/infra/ipsec-vpn-dpd-profiles/nsx-default-l3vpn-dpd-profile"
  ike_profile_path           = "/infra/ipsec-vpn-ike-profiles/nsx-default-l3vpn-ike-profile"
  tunnel_profile_path        = "/infra/ipsec-vpn-tunnel-profiles/nsx-default-l3vpn-tunnel-profile"
  enabled                    = true
  service_path               = nsxt_policy_ipsec_vpn_service.ipsec.path
  vpn_type                   = "RouteBased"
  authentication_mode        = "PSK"
  compliance_suite           = "NONE"
  ip_addresses               = [aws_vpn_connection.vpn_connection.tunnel1_cgw_inside_address]
  prefix_length              = var.vti_mask
  peer_address               = aws_vpn_connection.vpn_connection.tunnel1_address
  peer_id                    = aws_vpn_connection.vpn_connection.tunnel1_address
  psk                        = aws_vpn_connection.vpn_connection.tunnel1_preshared_key
  connection_initiation_mode = "INITIATOR"
}

resource "time_sleep" "wait_for_ipsec" {
  create_duration = "20s"
  depends_on      = [nsxt_policy_ipsec_vpn_session.ipsec-aws]
}

resource "nsxt_policy_bgp_neighbor" "vpn_gw" {
  depends_on            = [time_sleep.wait_for_ipsec]
  display_name          = "aws-vpn-connection"
  description           = "Terraform provisioned BgpNeighborConfig"
  bgp_path              = "/infra/tier-0s/${var.nsx_t0gw}/locale-services/default/bgp/neighbors/cloud_router"
  allow_as_in           = true
  graceful_restart_mode = "HELPER_ONLY"
  hold_down_time        = 300
  keep_alive_time       = 100
  neighbor_address      = aws_vpn_connection.vpn_connection.tunnel1_vgw_inside_address
  source_addresses      = [aws_vpn_connection.vpn_connection.tunnel1_cgw_inside_address]
  remote_as_num         = var.cloud_asn
  maximum_hop_limit     = "2"

  bfd_config {
    enabled  = true
    interval = 1000
    multiple = 4
  }
}
