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
  name = "CCOID-1"
}

resource "aci_vrf" "vrf1" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "VRF1"
}

resource "aci_bridge_domain" "bd1" {
  tenant_dn          = aci_tenant.terraform_tenant.id
  relation_fv_rs_ctx = aci_vrf.vrf1.name
  name               = "BD1"
}

resource "aci_subnet" "bd1_subnet" {
  bridge_domain_dn = aci_bridge_domain.bd1.id
  ip               = "172.16.1.254/24"
}