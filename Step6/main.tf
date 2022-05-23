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

variable "filters" {
   description = "Create filters with these names and ports"
   type        = map
   default     = {
     filter_https = {
       filter   = "https",
       entry    = "https",
       protocol = "tcp",
       port     = "443"
     },
     filter_sql = {
       filter   = "sql",
       entry    = "sql",
       protocol = "tcp",
       port     = "1433"
     }
   }
 }

 # Define an ACI Tenant Resource.
resource "aci_tenant" "terraform_tenant" {
  name = "CCOID-6"
}

 # Define an ACI Filter Resource.
 resource "aci_filter" "terraform_filter" {
     for_each    = var.filters
     tenant_dn   = aci_tenant.terraform_tenant.id
     description = "This is filter ${each.key} created by terraform"
     name        = each.value.filter
 }

 # Define an ACI Filter Entry Resource.
 resource "aci_filter_entry" "terraform_filter_entry" {
     for_each      = var.filters
     filter_dn     = aci_filter.terraform_filter[each.key].id
     name          = each.value.entry
     ether_t       = "ipv4"
     prot          = each.value.protocol
     d_from_port   = each.value.port
     d_to_port     = each.value.port
 }

