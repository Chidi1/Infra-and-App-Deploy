resource "azurerm_log_analytics_workspace" "demoworkspace" {
  location            = var.log_analytics_workspace_location
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "cpsolution" {
  location              = azurerm_log_analytics_workspace.demoworkspace.location
  resource_group_name   = var.resource_group_name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.demoworkspace.name
  workspace_resource_id = azurerm_log_analytics_workspace.demoworkspace.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}
