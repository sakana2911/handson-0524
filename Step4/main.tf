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
  username = " "
  # cisco-aci password
  password = " "
  # cisco-aci url
  url      = " "
  insecure = true
}

# Define an ACI Tenant Resource.
resource "aci_tenant" "terraform_tenant" {
  name = "CCOID-4"
}

# Define an ACI Tenant VRF Resource.
resource "aci_vrf" "vrf" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "VRF4"
}

# Define an ACI Tenant BD Resource.
resource "aci_bridge_domain" "bd" {
  tenant_dn          = aci_tenant.terraform_tenant.id
  relation_fv_rs_ctx = aci_vrf.vrf.id
  name               = "BD4"
}

# Define an ACI Application Profile Resource.
resource "aci_application_profile" "terraform_ap" {
    tenant_dn  = aci_tenant.terraform_tenant.id
    name       = "AP4"
    description = "App Profile Created Using Terraform"
}

# Define an ACI Application EPG Resource.
resource "aci_application_epg" "terraform_epg" {
    application_profile_dn  = aci_application_profile.terraform_ap.id
    name                    = "EPG4"
    relation_fv_rs_bd       = aci_bridge_domain.bd.id
    description             = "EPG Created Using Terraform"
}

# Associate the EPG Resources with Domain.
resource "aci_epg_to_domain" "terraform_epg_domain" {
    application_epg_dn    = aci_application_epg.terraform_epg.id
    tdn   = "uni/phys-MGMT_PD"
}

# Associate the EPG Resource with Static Path
resource "aci_epg_to_static_path" "terraform_static_path" {
    application_epg_dn = aci_application_epg.terraform_epg.id
    tdn = "topology/pod-1/protpaths-101-102/pathep-[HX1_PG]"
    encap = "vlan-200"
}
