# Terraform Cloudflare DNS Management

A simple, flexible Terraform module for managing Cloudflare DNS records. This configuration provides an easy way to create and manage DNS records across your Cloudflare-managed domains using Infrastructure as Code principles.

## 🚀 Features

- **Universal DNS Record Support**: Create any type of DNS record (A, AAAA, CNAME, MX, TXT, SRV, etc.)
- **Cloudflare Proxy Integration**: Enable/disable Cloudflare's security and performance features
- **Flexible TTL Management**: Configure custom TTL values or use Cloudflare's automatic setting
- **Secure Configuration**: API token-based authentication with sensitive variable handling
- **Simple Deployment**: Single-command deployment with plan review
- **State Management**: Full Terraform state tracking for reliable infrastructure management

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- Cloudflare account with domain management access
- Cloudflare API token with `Zone:DNS:Edit` permissions

## 🛠️ Quick Start

### 1. Clone and Setup
```bash
git clone https://github.com/your-username/terraform-cloudflare-dns.git
cd terraform-cloudflare-dns
```

### 2. Configure Variables
Copy the example configuration and customize it with your settings:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then edit `terraform.tfvars` with your actual values. The example file contains comprehensive documentation and examples for all supported record types:

```hcl
cloudflare_api_token = "your-cloudflare-api-token"
zone_id             = "your-zone-id-from-cloudflare"

# Define multiple DNS records
dns_records = {
  "www" = {
    name    = "www"
    type    = "A"
    content = "203.0.113.1"
    ttl     = 300
    proxied = true
    comment = "Main website"
  }
  
  "api" = {
    name    = "api"
    type    = "A"
    content = "203.0.113.2"
    proxied = true
    comment = "API endpoint"
  }
  
  "blog" = {
    name    = "blog"
    type    = "CNAME"
    content = "blog.example.dev"
    proxied = false
    comment = "Blog subdomain"
  }
}
```

### 3. Deploy
```bash
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply configuration
terraform apply
```

## 📂 Repository Structure

This is a Git repository with the following structure:

```
terraform-cloudflare-dns/
├── README.md                 # This documentation
├── main.tf                   # Main Terraform configuration
├── variables.tf              # Variable definitions
├── terraform.tfvars.example  # Example configuration with documentation
├── terraform.tfvars          # Your configuration (not in git)
├── .gitignore               # Git ignore rules
└── .git/                    # Git repository data
```

**Important Files:**
- `main.tf` - Contains the Cloudflare provider and DNS record resource
- `variables.tf` - Defines all configurable variables with descriptions
- `terraform.tfvars.example` - Comprehensive example with documentation for all record types
- `terraform.tfvars` - Your personal configuration (excluded from git for security)

## 📖 Configuration Reference

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `cloudflare_api_token` | API token with DNS edit permissions | `"abc123..."` |
| `zone_id` | Cloudflare zone ID for your domain | `"def456..."` |
| `dns_records` | Map of DNS records to create | See examples below |

### DNS Record Structure

Each record in the `dns_records` map supports these properties:

| Property | Required | Description | Example |
|----------|----------|-------------|---------|
| `name` | ✅ | DNS record name | `"www"`, `"api"`, `"@"` |
| `type` | ✅ | DNS record type | `"A"`, `"CNAME"`, `"MX"`, etc. |
| `content` | ✅ | Record target content | `"192.0.2.1"`, `"example.com"` |
| `ttl` | ❌ | Time to live in seconds | `300`, `3600` |
| `proxied` | ❌ | Enable Cloudflare proxy | `true`, `false` |
| `comment` | ❌ | Record description | `"Main website"` |

### Global Defaults

| Variable | Description | Default |
|----------|-------------|---------|
| `default_ttl` | Default TTL for records | `1` (automatic) |
| `default_proxied` | Default proxy setting | `false` |

## 💡 Usage Examples

### Complete Multi-Record Setup
```hcl
dns_records = {
  # Website records
  "www" = {
    name    = "www"
    type    = "A"
    content = "203.0.113.1"
    ttl     = 300
    proxied = true
    comment = "Main website"
  }
  
  "root" = {
    name    = "@"
    type    = "A"
    content = "203.0.113.1"
    ttl     = 300
    proxied = true
    comment = "Root domain"
  }
  
  # API and services
  "api" = {
    name    = "api"
    type    = "A"
    content = "203.0.113.2"
    proxied = true
    comment = "API endpoint"
  }
  
  "blog" = {
    name    = "blog"
    type    = "CNAME"
    content = "blog.example.dev"
    proxied = false
    comment = "Blog subdomain"
  }
  
  # Mail configuration
  "mail-mx" = {
    name    = "@"
    type    = "MX"
    content = "10 mail.example.com"
    comment = "Primary mail server"
  }
  
  "mail-mx-backup" = {
    name    = "@"
    type    = "MX"
    content = "20 backup.mail.example.com"
    comment = "Backup mail server"
  }
  
  # Email security
  "spf" = {
    name    = "@"
    type    = "TXT"
    content = "v=spf1 include:_spf.google.com ~all"
    comment = "SPF record"
  }
  
  "dmarc" = {
    name    = "_dmarc"
    type    = "TXT"
    content = "v=DMARC1; p=quarantine; rua=mailto:dmarc@example.com"
    comment = "DMARC policy"
  }
  
  # Services
  "ftp" = {
    name  = "ftp"
    type  = "CNAME"
    content = "ftp.provider.com"
    comment = "FTP service"
  }
}
```

### Single Record Type Examples

#### A Record (IPv4)
```hcl
dns_records = {
  "www" = {
    name    = "www"
    type    = "A"
    content = "203.0.113.1"
    proxied = true
  }
}
```

#### CNAME Record
```hcl
dns_records = {
  "blog" = {
    name    = "blog"
    type    = "CNAME"
    content = "my-blog.example.dev"
    proxied = false
  }
}
```

#### MX Record
```hcl
dns_records = {
  "mail" = {
    name  = "@"
    type  = "MX"
    content = "10 mail.example.com"
  }
}
```

#### TXT Record (SPF)
```hcl
dns_records = {
  "spf" = {
    name  = "@"
    type  = "TXT"
    content = "v=spf1 include:_spf.google.com ~all"
  }
}
```

## 🔧 Advanced Usage

### Managing Large Numbers of Records

The new scalable design makes it easy to manage many DNS records:

```hcl
dns_records = {
  # Production web services
  "www"     = { name = "www", type = "A", content = "203.0.113.1", proxied = true }
  "api"     = { name = "api", type = "A", content = "203.0.113.2", proxied = true }
  "admin"   = { name = "admin", type = "A", content = "203.0.113.3", proxied = true }
  
  # Development services
  "dev-www" = { name = "dev-www", type = "A", content = "203.0.113.10", proxied = false }
  "dev-api" = { name = "dev-api", type = "A", content = "203.0.113.11", proxied = false }
  
  # Mail and security
  "mail"    = { name = "@", type = "MX", content = "10 mail.example.com" }
  "spf"     = { name = "@", type = "TXT", content = "v=spf1 include:_spf.google.com ~all" }
  "dkim"    = { name = "selector1._domainkey", type = "TXT", content = "v=DKIM1; k=rsa; p=..." }
  
  # CDN and services
  "cdn"     = { name = "cdn", type = "CNAME", content = "cdn.provider.com", proxied = false }
  "ftp"     = { name = "ftp", type = "CNAME", content = "ftp.provider.com" }
}
```

### Environment Separation
For different environments, you can use Terraform workspaces or different tfvars files:

```bash
# Production
terraform workspace new production
terraform apply -var-file="production.tfvars"

# Staging
terraform workspace new staging  
terraform apply -var-file="staging.tfvars"
```

### State Management
For production use, configure remote state:

```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "cloudflare-dns/terraform.tfstate"
    region = "us-west-2"
  }
}
```

## 🔒 Security Best Practices

1. **API Token Scope**: Create tokens with minimal required permissions (`Zone:DNS:Edit`)
2. **Variable Security**: Never commit `terraform.tfvars` to version control (handled by .gitignore)
3. **State Security**: Use encrypted remote state backends for production
4. **Access Control**: Limit Terraform access to authorized team members only

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/terraform-cloudflare-dns.git
   ```
3. Create a feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```
4. Make your changes
5. Test your changes thoroughly

### Code Standards
- Follow HashiCorp's Terraform style guide
- Use meaningful variable names and descriptions
- Include examples for new features
- Update documentation for any changes

### Testing
Before submitting changes:
```bash
# Validate Terraform syntax
terraform validate

# Format code consistently
terraform fmt -check

# Test with a non-production zone
terraform plan
```

### Submitting Changes

1. Commit your changes:
   ```bash
   git add .
   git commit -m 'Add amazing feature'
   ```
2. Push to your branch:
   ```bash
   git push origin feature/amazing-feature
   ```
3. Open a Pull Request on GitHub with:
   - Clear description of changes
   - Test results
   - Breaking change notes (if any)

### Reporting Issues
- Use GitHub Issues for bug reports and feature requests
- Include Terraform version, provider version, and error messages
- Provide minimal reproduction examples

## 📋 Outputs

This configuration provides the following outputs:
- `dns_record_id`: The unique ID of the created DNS record
- `dns_record_hostname`: The full hostname of the created record

## 🆘 Troubleshooting

### Common Issues

**Invalid API Token**: Ensure your token has `Zone:DNS:Edit` permissions for the target zone

**Zone ID Not Found**: Verify the zone ID from your Cloudflare dashboard

**Record Already Exists**: Check for existing records with the same name and type

**Validation Errors**: Run `terraform validate` to check configuration syntax

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Cloudflare Terraform Provider](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
- [HashiCorp Terraform](https://www.terraform.io/)

---

**⚠️ Important**: Always run `terraform plan` before `terraform apply` to review changes. Never commit sensitive information like API tokens to version control.
