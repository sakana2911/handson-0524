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
  name = "CCOID-5"
}

# Define an ACI Tenant VRF Resource.
resource "aci_vrf" "vrf" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "VRF5"
}

# Define an ACI Tenant BD Resource.
resource "aci_bridge_domain" "bd" {
  tenant_dn          = aci_tenant.terraform_tenant.id
  relation_fv_rs_ctx = aci_vrf.vrf.id
  name               = "BD5"
}

# Define an ACI Application Profile Resource.
resource "aci_application_profile" "terraform_ap" {
    tenant_dn  = aci_tenant.terraform_tenant.id
    name       = "AP5"
    description = "App Profile Created Using Terraform"
}

# Define an ACI Application EPG Resource.
resource "aci_application_epg" "terraform_epg" {
    application_profile_dn  = aci_application_profile.terraform_ap.id
    name                    = "EPG5"
    relation_fv_rs_bd       = aci_bridge_domain.bd.id
    description             = "EPG Created Using Terraform"
}

# Define an ACI Filter Resource.
resource "aci_filter" "terraform_filter" {
    tenant_dn   = aci_tenant.terraform_tenant.id
    name        = "Allow-HTTP-filter"
}

# Define an ACI Filter Entry Resource.
resource "aci_filter_entry" "terraform_filter_entry" {
    filter_dn     = aci_filter.terraform_filter.id
    name          = "http"
    ether_t       = "ipv4"
    prot          = "tcp"
    d_from_port   = "80"
    d_to_port     = "80"
}

# Define an ACI Contract Resource.
resource "aci_contract" "terraform_contract" {
    tenant_dn     = aci_tenant.terraform_tenant.id
    name          = "Allow-HTTP-Contract"
}

# Define an ACI Contract Subject Resource.
resource "aci_contract_subject" "terraform_contract_subject" {
    contract_dn                   = aci_contract.terraform_contract.id
    name                          = "Allow-HTTP-Subject"
    relation_vz_rs_subj_filt_att  = [aci_filter.terraform_filter.id]
}

# Associate the EPGs with the contrats
resource "aci_epg_to_contract" "terraform_epg_contract" {
    application_epg_dn = aci_application_epg.terraform_epg.id
    contract_dn        = aci_contract.terraform_contract.id
    contract_type      = "provider"
}
