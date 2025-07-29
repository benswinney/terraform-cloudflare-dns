terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.3.0" # Updated for optional() support
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
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.ttl != null ? each.value.ttl : var.default_ttl
  proxied = each.value.proxied != null ? each.value.proxied : var.default_proxied

  # Optional comment for record identification
  comment = each.value.comment != null ? each.value.comment : "Managed by Terraform"

  # Lifecycle management to prevent accidental deletion
  lifecycle {
    prevent_destroy       = false # Set to true for production environments
    create_before_destroy = true
  }
}

