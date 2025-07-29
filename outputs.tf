# Output all created record details
output "dns_record_details" {
  description = "Details of all created DNS records"
  value = {
    for key, record in cloudflare_record.dns_records : key => {
      id       = record.id
      hostname = record.hostname
      name     = record.name
      type     = record.type
      content  = record.content
      ttl      = record.ttl
      proxied  = record.proxied
      comment  = record.comment
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

# Output record count for monitoring
output "dns_record_count" {
  description = "Total number of DNS records created"
  value       = length(cloudflare_record.dns_records)
}

# Output records by type for analysis
output "dns_records_by_type" {
  description = "DNS records grouped by type"
  value = {
    for type in distinct([for record in cloudflare_record.dns_records : record.type]) : type => [
      for key, record in cloudflare_record.dns_records : key if record.type == type
    ]
  }
}