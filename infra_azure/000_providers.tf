# This is a Terraform file that defines the providers that will be used in the project.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "databricks-byt"
    storage_account_name = "gyrusdatabricksbyt"
    container_name       = "tfstate"
    key                  = "infra_azure.tfstate"
  }
}

provider "azurerm" {
  features {}
}
