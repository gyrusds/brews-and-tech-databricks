# This is a Terraform file that defines the providers that will be used in the project.

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "<1.44.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "databricks-byt"
    storage_account_name = "gyrusdatabricksbyt"
    container_name       = "tfstate"
    key                  = "infra_databricks.tfstate"
  }
}

# This data is a terraform remote state from the infra_azure project (the other folder in this repository).
# It is used to get the host of the Databricks workspace.
data "terraform_remote_state" "infra_azure" {
  backend = "azurerm"
  config = {
    resource_group_name  = "databricks-byt"
    storage_account_name = "gyrusdatabricksbyt"
    container_name       = "tfstate"
    key                  = "infra_azure.tfstate"
  }
}
provider "databricks" {
  host = data.terraform_remote_state.infra_azure.outputs.host
}

