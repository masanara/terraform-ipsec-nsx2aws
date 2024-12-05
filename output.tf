output "VPN_GW_IP" {
  value = aws_vpn_connection.vpn_connection.tunnel1_address
}
output "PS_KEY" {
  value = nonsensitive(aws_vpn_connection.vpn_connection.tunnel1_preshared_key)
}
output "CGW_ADDRESS" {
  value = aws_vpn_connection.vpn_connection.tunnel1_cgw_inside_address
}
output "VGW_ADDRESS" {
  value = aws_vpn_connection.vpn_connection.tunnel1_vgw_inside_address
}
