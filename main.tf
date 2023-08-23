module "transit_adoption_framework" {
  source  = "terraform-aviatrix-modules/mc-transit-deployment-framework/aviatrix"
  version = "v1.1.1"

  default_transit_accounts = {
    azure = var.azure_account,
    gcp   = var.gcp_account,
  }

  default_firenet_firewall_image = {
    #https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_firewall_instance#firewall_image  
    azure = "Fortinet FortiGate (PAYG_20190624) Next-Generation Firewall Latest Release",
    gcp   = "Palo Alto Networks VM-Series Next-Generation Firewall BUNDLE1",
  }

  peering_mode = "custom"
  peering_map = {
    aws_peering : {
      gw1_name = module.transit_adoption_framework.transit["azure_transit_firenet"].transit_gateway.gw_name,
      gw2_name = module.transit_adoption_framework.transit["gcp_transit_firenet"].transit_gateway.gw_name,
    },
    azure_peering : {
      gw1_name = module.transit_adoption_framework.transit["aws_transit_firenet"].transit_gateway.gw_name,
      gw2_name = module.transit_adoption_framework.transit["gcp_transit_firenet"].transit_gateway.gw_name,
    },
    gcp_peering : {
      gw1_name = module.transit_adoption_framework.transit["azure_transit_firenet"].transit_gateway.gw_name,
      gw2_name = module.transit_adoption_framework.transit["aws_transit_firenet"].transit_gateway.gw_name,
    },
  }

  transit_firenet = {
    aws_transit_firenet = {
      transit_cloud       = "aws",
      transit_cidr        = "10.103.0.0/16",
      transit_region_name = var.aws_region,
      transit_asn         = 64514,
      firenet             = true
    },
    azure_transit_firenet = {
      transit_cloud       = "azure",
      transit_cidr        = "10.101.0.0/16",
      transit_region_name = var.azure_region,
      transit_asn         = 64512,
      firenet             = true
      firenet_user_data_1 = local.azure_fw1
      firenet_user_data_2 = local.azure_fw2
    },
    gcp_transit_firenet = {
      transit_cloud       = "gcp",
      transit_cidr        = "10.102.0.0/20",
      transit_lan_cidr    = "10.102.16.0/20",
      transit_region_name = var.gcp_region,
      transit_asn         = 64513,
      firenet_egress_cidr = "10.102.32.0/20",
      firenet_mgmt_cidr = "10.102.48.0/20",
      firenet             = true
    #   firenet_user_data_1 = local.gcp_fw1 #This bootstrapping method does not work in the exact same way as in Azure/AWS. Need to look into it.
    #   firenet_user_data_2 = local.gcp_fw2 #This bootstrapping method does not work in the exact same way as in Azure/AWS. Need to look into it.
    },
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "spokes" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.2.1"

  for_each = local.spokes

  cloud      = each.value.cloud
  name       = each.value.name
  cidr       = each.value.cidr
  region     = each.value.region
  account    = each.value.account
  transit_gw = each.value.transit_gw
}

