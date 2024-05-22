resource "azurerm_databricks_workspace" "main" {
  name                = local.project_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = "standard"

  tags = local.tags
}
