terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "2.2.1"
    }
  }
}

provider "aci" {
  # cisco-aci user name
  username = "admin"
  # cisco-aci password
  password = "C!Sco_1234"
  # cisco-aci url
  url      = "172.16.10.11"
  insecure = true
}

# Define an ACI Tenant Resource.
resource "aci_tenant" "terraform_tenant" {
  name = "CCOID-3"
}

# Define an ACI Tenant VRF Resource.
resource "aci_vrf" "vrf" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "VRF3"
}

# Define an ACI Tenant BD Resource.
resource "aci_bridge_domain" "bd" {
  tenant_dn          = aci_tenant.terraform_tenant.id
  relation_fv_rs_ctx = aci_vrf.vrf.id
  name               = "BD3"
}

# Define an ACI Application Profile Resource.
resource "aci_application_profile" "terraform_ap" {
    tenant_dn  = aci_tenant.terraform_tenant.id
    name       = "AP3"
    description = "App Profile Created Using Terraform"
}

# Define an ACI Application EPG Resource.
resource "aci_application_epg" "terraform_epg" {
    application_profile_dn  = aci_application_profile.terraform_ap.id
    name                    = "EPG3"
    relation_fv_rs_bd       = aci_bridge_domain.bd.id
    description             = "EPG Created Using Terraform"
}