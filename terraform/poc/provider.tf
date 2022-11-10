# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  backend "azurerm" {
     resource_group_name = "poc-centric-tf-rg-ae-1"
     storage_account_name = "poccentrictfsaae1"
     container_name = "poc-centric-tf-blob-ae-1"
     key    = "poc-centric-project.tfstate"
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
