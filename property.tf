terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 10.3.0 "
    }
  }
  required_version = ">= 1.0"
}

provider "akamai" {
  edgerc         = var.edgerc_path
  config_section = var.config_section
}

data "akamai_property_rules_template" "rules" {
  template_file = abspath("${path.module}/property-snippets/main.json")
}

resource "akamai_edge_hostname" "waap-akamaiuwebfraud-com-edgekey-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV6_COMPLIANCE"
  product_id    = "prd_SPM"
  edge_hostname = "waap.akamaiuwebfraud.com.edgekey.net"
  certificate   = 204115
}

resource "akamai_property" "_2608-x4s6" {
  name        = "2608-x4s6"
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = "prd_SPM"
  hostnames {
    cname_from             = "2608-x4s6.akamaiuwebfraud.com"
    cname_to               = akamai_edge_hostname.waap-akamaiuwebfraud-com-edgekey-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  rule_format = "v2022-10-18"
  rules       = data.akamai_property_rules_template.rules.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "_2608-x4s6-staging" {
  property_id                    = akamai_property._2608-x4s6.id
  contact                        = ["noreply@akamai.com"]
  version                        = var.activate_latest_on_staging ? akamai_property._2608-x4s6.latest_version : akamai_property._2608-x4s6.staging_version
  network                        = "STAGING"
  note                           = "Initial Config"
  auto_acknowledge_rule_warnings = true
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "_2608-x4s6-production" {
  property_id                    = akamai_property._2608-x4s6.id
  contact                        = ["noreply@akamai.com", "waap7889@akamaiu.com"]
  version                        = 2
  network                        = "PRODUCTION"
  note                           = "Activating version 2 on production"
  auto_acknowledge_rule_warnings = false
}
