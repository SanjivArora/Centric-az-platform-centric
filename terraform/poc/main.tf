resource "azurerm_resource_group" "this_rg" {
  name     = "${var.environment}-${var.solution_name}-networking-rg-${var.location_short_name}-1"
  location = var.location

  tags = merge(
    local.common_tags, {
      Name        = "${var.environment}-${var.solution_name}-networking-rg-${var.location_short_name}-1"
    }
  )
}

module "vnet" {
    source = "../modules/network"
    resource_group_name = azurerm_resource_group.this_rg.name
    address_space = ["10.166.138.0/25"]
    subnet_prefixes = [
        "10.166.138.0/28", 
        "10.166.138.16/28", 
        "10.166.138.32/28",
        "10.166.138.48/28",
        "10.166.138.64/27",
        "10.166.138.96/27"
        ]
    subnet_names = [        
        "${var.environment}-${var.solution_name}-appservice-sn-${var.location_short_name}-1", 
        "${var.environment}-${var.solution_name}-webapp-sn-${var.location_short_name}-1", 
        "${var.environment}-${var.solution_name}-appgw-sn-${var.location_short_name}-1",
        "${var.environment}-${var.solution_name}-vm-sn-${var.location_short_name}-1",
        "${var.environment}-${var.solution_name}-sqlmi-sn-${var.location_short_name}-1",
        "${var.environment}-${var.solution_name}-extra-sn-${var.location_short_name}-1"
        ]
    vnet_location = azurerm_resource_group.this_rg.location
    common_tags = local.common_tags
    location_short_name = var.location_short_name
    environment = var.environment
    solution_name = var.solution_name

  subnet_delegation = {
    "${var.environment}-${var.solution_name}-appservice-sn-${var.location_short_name}-1" = {
      "Microsoft.Web.serverFarms" = {
        service_name = "Microsoft.Web/serverFarms"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    },
    "${var.environment}-${var.solution_name}-webapp-sn-${var.location_short_name}-1" = {
      "Microsoft.Web.serverFarms" = {
        service_name = "Microsoft.Web/serverFarms"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    },
    "${var.environment}-${var.solution_name}-sqlmi-sn-${var.location_short_name}-1" = {
      "Microsoft.Sql/managedInstances" = {
        service_name = "Microsoft.Sql/managedInstances"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action", 
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", 
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
      }
    }
  }

  # route_tables_ids = {
  #   "${var.environment}-${var.solution_name}-app-sn-${var.location_short_name}-1" = azurerm_route_table.this_table.id
  # }
}

# resource "azurerm_route_table" "this_table" {
#   location            = azurerm_resource_group.this_rg.location
#   name                = "${var.environment}-${var.solution_name}-rt-${var.location_short_name}-1"
#   resource_group_name = azurerm_resource_group.this_rg.name

#   route {
#     name                   = "Default"
#     address_prefix         = "10.0.0.0/8"
#     next_hop_type          = "VirtualAppliance"
#     next_hop_in_ip_address = var.gateway_address
#   }
#   tags = merge(
#     var.common_tags,
#     {
#       Name        = "${var.environment}-${var.solution_name}-rt-${var.location_short_name}-1"
#       description = "Default route table for app subnets in Australia East region"
#     }
#   )
# }
