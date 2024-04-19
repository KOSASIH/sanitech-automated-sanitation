resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diagnostic-setting"
  target_resource_id = data.azurerm_resource_group.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category ="Administrative"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-logs"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

data "azurerm_subscription" "primary" {}
