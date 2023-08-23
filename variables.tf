variable "azure_region" {
  type    = string
  default = "East US"
}

variable "gcp_region" {
  type    = string
  default = "us-east1"
}

variable "aws_region" {
  type    = string
  default = "us-east1"
}

variable "azure_account" {
  type    = string
  default = "Azure_Paul_New"
}

variable "gcp_account" {
  type    = string
  default = "GCP_Paul"
}

variable "aws_account" {
  type    = string
  default = "AWS_Paul"
}

variable "ctlpassword" {
  type    = string
}

locals {
  

  spokes = {
    azure_spoke_1 = {
      cloud      = "Azure",
      name       = "azure-vdc-Spoke-1",
      cidr       = "10.1.0.0/16",
      region     = var.azure_region,
      account    = var.azure_account,
      transit_gw = module.transit_adoption_framework.transit["azure_transit_firenet"].transit_gateway.gw_name,
    },
    gcp_spoke_1 = {
      cloud      = "GCP",
      name       = "gcp-cne-spoke-1",
      cidr       = "10.11.0.0/16",
      region     = var.gcp_region,
      account    = var.gcp_account,
      transit_gw = module.transit_adoption_framework.transit["gcp_transit_firenet"].transit_gateway.gw_name,
    },
    azure_spoke_2 = {
      cloud      = "Azure",
      name       = "azure-CNE-Spoke-2",
      cidr       = "10.2.0.0/16",
      region     = var.azure_region,
      account    = var.azure_account,
      transit_gw = module.transit_adoption_framework.transit["azure_transit_firenet"].transit_gateway.gw_name,
    },
    gcp_spoke_2 = {
      cloud      = "GCP",
      name       = "gcp-cne-spoke-2",
      cidr       = "10.12.0.0/16",
      region     = var.gcp_region,
      account    = var.gcp_account,
      transit_gw = module.transit_adoption_framework.transit["gcp_transit_firenet"].transit_gateway.gw_name,
    },
    azure_spoke_3 = {
      cloud      = "Azure",
      name       = "azure-CNE-Spoke-3",
      cidr       = "10.3.0.0/16",
      region     = var.azure_region,
      account    = var.azure_account,
      transit_gw = module.transit_adoption_framework.transit["azure_transit_firenet"].transit_gateway.gw_name,
    },
    gcp_spoke_3 = {
      cloud      = "GCP",
      name       = "gcp-cne-spoke-3",
      cidr       = "10.13.0.0/16",
      region     = var.gcp_region,
      account    = var.gcp_account,
      transit_gw = module.transit_adoption_framework.transit["gcp_transit_firenet"].transit_gateway.gw_name,
    },
    azure_spoke_4 = {
      cloud      = "Azure",
      name       = "azure-CNE-Spoke-4",
      cidr       = "10.4.0.0/16",
      region     = var.azure_region,
      account    = var.azure_account,
      transit_gw = module.transit_adoption_framework.transit["azure_transit_firenet"].transit_gateway.gw_name,
    },
    gcp_spoke_4 = {
      cloud      = "GCP",
      name       = "gcp-cne-spoke-4",
      cidr       = "10.14.0.0/16",
      region     = var.gcp_region,
      account    = var.gcp_account,
      transit_gw = module.transit_adoption_framework.transit["gcp_transit_firenet"].transit_gateway.gw_name,
    },
  }
}


