# terraform-ipsec-nsx2aws

AWS Virtual Private Gateway と NSX T0GW 間でIPsec VPN接続を構成します。

1. AWS上に新たにVPC、サブネット、仮想プライベートゲートウェイ、カスタマーゲートウェイ、Site-to-Site VPN接続を作成。
2. オンプレミスのNSXの既存T0GWに対してVTIとIPsecを構成し、作成したAWS 仮想プライベートゲートウェイにしてIPsec接続を構成。


- terraform.tfvars

```
vpc_cidr           = "10.0.0.0/16"     # VPCのCIDR
region             = "ap-northeast-1"  # VPCを作成するリージョン
availability_zones = ["ap-northeast-1a", "ap-northeast-1c"] # サブネットを作成するAZ

local_asn = "65413"                    # オンプレミス側のT0GWのAS番号 (要事前設定)
cloud_asn = "65412"                    # 作成するVPN GatewayのAS番号

local_ep      = "203.0.113.100"        # ローカルエンドポイントのIPアドレス
local_address = "198.51.100.10"        # ローカルエンドポイントのローカルID
nsx_host      = "192.0.2.20"           # NSX ManagerのIPアドレス
nsx_username  = "admin"                # NSX Managerのログインユーザー名
nsx_password  = "NsxAdminP@ssword"     # NSX Managerのログインパスワード
nsx_t0gw      = "t0gw"                 # 既存のT0 Gatewayの名称
```