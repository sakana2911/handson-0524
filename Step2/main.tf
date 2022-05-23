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
resource "aci_tenant" "terraform_tenant" {
  name = "CCOID-2"
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