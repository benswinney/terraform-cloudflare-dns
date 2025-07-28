terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Configure the Cloudflare provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Create multiple DNS records
resource "cloudflare_record" "dns_records" {
  for_each = var.dns_records

  zone_id = var.zone_id
  name    = each.value.name
  value   = each.value.value
  type    = each.value.type
  ttl     = lookup(each.value, "ttl", var.default_ttl)
  proxied = lookup(each.value, "proxied", var.default_proxied)
  
  # Optional comment for record identification
  comment = lookup(each.value, "comment", "Managed by Terraform")
}

# Output all created record details
output "dns_record_details" {
  description = "Details of all created DNS records"
  value = {
    for key, record in cloudflare_record.dns_records : key => {
      id       = record.id
      hostname = record.hostname
      name     = record.name
      type     = record.type
      value    = record.value
      ttl      = record.ttl
      proxied  = record.proxied
    }
  }
}

# Output record IDs for reference
output "dns_record_ids" {
  description = "Map of record keys to their IDs"
  value = {
    for key, record in cloudflare_record.dns_records : key => record.id
  }
}
