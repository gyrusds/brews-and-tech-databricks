locals {
  project_name        = "bytsession-databricks"
  environment         = "bytsession"
  resource_group_name = "databricks-byt"
  location            = "westeurope"

  tags = {
    project     = local.project_name
    terraform   = "True"
    respository = "brews-and-tech-databricks"
  }
}
