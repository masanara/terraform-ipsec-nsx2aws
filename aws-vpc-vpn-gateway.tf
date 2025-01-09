data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id          = data.aws_vpc.vpc.id
  amazon_side_asn = var.cloud_asn
}

resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = var.local_asn
  ip_address = var.local_ep
  type       = "ipsec.1"
  tags = {
    Name = "nsxt-customer-gateway"
  }
}

resource "aws_vpn_connection" "vpn_connection" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = "ipsec.1"
  static_routes_only  = false
}
