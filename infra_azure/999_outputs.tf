
output "host" {
  value       = azurerm_databricks_workspace.main.workspace_url
  description = "Use this value to connect to the Databricks workspace."
}
