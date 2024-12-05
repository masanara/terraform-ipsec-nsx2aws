variable "local_asn" {
  type = string
}

variable "cloud_asn" {
  type = string
}

variable "vti_mask" {
  type    = string
  default = "30"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "peer_external_gateway" {
  type    = string
  default = "myhome"
}

variable "router" {
  type    = string
  default = "cust-router"
}

variable "local_ep" {
  type = string
}

variable "local_address" {
  type = string
}

variable "nsx_host" {
  type = string
}

variable "nsx_username" {
  type = string
}

variable "nsx_password" {
  type = string
}

variable "nsx_t0gw" {
  type = string
}
