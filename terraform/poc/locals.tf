locals {
  default_common_tags = {
    cost-centre     = "12333"
    owner           = "Cloud Services Team"
    business-entity = "WDHB"
    environment     = "Poc"
    security-zone   = "Manage"
    role            = "Infrastructure"
    application     = "Centric"
    app-tier        = "Application"
    app-criticality = "Tier 2"
  }
  common_tags = merge(local.default_common_tags, var.common_tags)

}