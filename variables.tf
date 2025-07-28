variable "cloudflare_api_token" {
  description = "Cloudflare API Token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "zone_id" {
  description = "The DNS zone ID where the records will be created"
  type        = string
}

variable "dns_records" {
  description = "Map of DNS records to create"
  type = map(object({
    name    = string
    type    = string
    value   = string
    ttl     = optional(number)
    proxied = optional(bool)
    comment = optional(string)
  }))

  validation {
    condition = alltrue([
      for k, v in var.dns_records : contains([
        "A", "AAAA", "CNAME", "MX", "TXT", "SRV", "CAA", "NS", "PTR"
      ], v.type)
    ])
    error_message = "DNS record type must be one of: A, AAAA, CNAME, MX, TXT, SRV, CAA, NS, PTR."
  }

  validation {
    condition = alltrue([
      for k, v in var.dns_records : v.ttl == null || (v.ttl >= 1 && v.ttl <= 86400)
    ])
    error_message = "TTL must be between 1 and 86400 seconds, or null for automatic."
  }
}

variable "default_ttl" {
  description = "Default TTL for records that don't specify one (1 = automatic)"
  type        = number
  default     = 1
  
  validation {
    condition     = var.default_ttl >= 1 && var.default_ttl <= 86400
    error_message = "Default TTL must be between 1 and 86400 seconds."
  }
}

variable "default_proxied" {
  description = "Default proxy setting for records that don't specify one"
  type        = bool
  default     = false
}
