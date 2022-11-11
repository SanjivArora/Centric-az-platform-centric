# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  backend "azurerm" {
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.25.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}
