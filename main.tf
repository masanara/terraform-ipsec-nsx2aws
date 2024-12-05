terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.7.1"
    }
  }
}

provider "nsxt" {
  host                 = var.nsx_host
  username             = var.nsx_username
  password             = var.nsx_password
  allow_unverified_ssl = true
  max_retries          = 2
}

provider "aws" {
  region = var.region
}
