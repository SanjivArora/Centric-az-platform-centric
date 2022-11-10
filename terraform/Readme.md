##### Example Usage #####

##### This Module is used to provision VNET, Subnets, Network wathcer, NSG and route Table assocciation####

#### Resources Created #####
1. azurerm_subnet.subnet
2. azurerm_subnet_network_security_group_association.vnet
3. azurerm_subnet_route_table_association.vnet
4. azurerm_virtual_network.vnet
5. azurerm_network_watcher.network_watcher

resource "azurerm_resource_group" "this_rg" {
  name     = "${var.environment}-${var.solution_name}-networking-rg-${var.location_short_name}-1"
  location = var.location

  tags = merge(
    var.common_tags, {
      Name        = "${var.environment}-${var.solution_name}-networking-rg-${var.location_short_name}-1"
    }
  )
}

module "vnet" {
    source = "../modules/network"
    resource_group_name = azurerm_resource_group.this_rg.name
    address_space = ["10.0.0.0/16"]
    subnet_prefixes = [
        "10.0.1.0/24", 
        "10.0.2.0/24", 
        "10.0.3.0/24"
        ]
    subnet_names = [        
        "${var.environment}-${var.solution_name}-data-sn-${var.location_short_name}-1", 
        "${var.environment}-${var.solution_name}-app-sn-${var.location_short_name}-1", 
        "${var.environment}-${var.solution_name}-sql-sn-${var.location_short_name}-1"
        ]
    vnet_location = azurerm_resource_group.this_rg.location
    common_tags = local.common_tags
    location_short_name = var.location_short_name
    environment = var.environment
    solution_name = var.solution_name

    nsg_ids = {
        "${var.environment}-${var.solution_name}-data-sn-${var.location_short_name}-1" = azurerm_network_security_group.this_nsg.id
    }

    subnet_service_endpoints = {
        "${var.environment}-${var.solution_name}-app-sn-${var.location_short_name}-1" = ["Microsoft.Storage"],
        "${var.environment}-${var.solution_name}-sql-sn-${var.location_short_name}-1" = ["Microsoft.Sql"]
    }

  subnet_delegation = {
    "${var.environment}-${var.solution_name}-sql-sn-${var.location_short_name}-1" = {
      "Microsoft.Sql.managedInstances" = {
        service_name = "Microsoft.Sql/managedInstances"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      }
    }
  }

  route_tables_ids = {
    "${var.environment}-${var.solution_name}-data-sn-${var.location_short_name}-1" = azurerm_route_table.this_table.id
  }
}

resource "azurerm_network_security_group" "this_nsg" {
  location            = azurerm_resource_group.this_rg.location
  name                = "${var.environment}-${var.solution_name}-nsg-${var.location_short_name}-1"
  resource_group_name = azurerm_resource_group.this_rg.name

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "test123"
    priority                   = 100
    protocol                   = "Tcp"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    source_address_prefix      = ""
    source_port_range          = "*"
  }
}

resource "azurerm_route_table" "this_table" {
  location            = azurerm_resource_group.this_rg.location
  name                = "${var.environment}-${var.solution_name}-rt-${var.location_short_name}-1"
  resource_group_name = azurerm_resource_group.this_rg.name

  route {
    name                   = "Default"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.1.1.1"
  }
}

resource "azurerm_route" "this_route" {
  address_prefix      = "10.1.0.0/16"
  name                = "${var.environment}-${var.solution_name}-route-${var.location_short_name}-1"
  next_hop_type       = "VnetLocal"
  resource_group_name = azurerm_resource_group.this_rg.name
  route_table_name    = azurerm_route_table.this_table.name
}