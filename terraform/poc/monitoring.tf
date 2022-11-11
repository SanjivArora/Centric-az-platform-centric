resource "azurerm_resource_group" "logging" {
  name     = "${var.environment}-${var.solution_name}-networking-rg-${var.location_short_name}-1"
  location = var.location

  tags = merge(
    local.common_tags, {
      Name        = "${var.environment}-${var.solution_name}-networking-rg-${var.location_short_name}-1"
    }
  )
}


module "monitoring" {
  source                                     = "../modules/monitoring"
  common_tags                                = local.common_tags
  rg_name                                    = azurerm_resource_group.logging.name
  environment                                = var.environment
  depends_on = [
    azurerm_resource_group.this_rg,
  ]
}
