resource "azurerm_monitor_activity_log_alert" "example" {
  name                = "example-activity-log-alert"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [data.azurerm_subscription.primary.id]

  criteria {
    category = "Administrative"
    operation_name = "Microsoft.Compute/virtualMachines/write"
    level             = "Critical"
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

resource "azurerm_monitor_action_group" "example" {
  name                = "example-action-group"
  resource_group_name = azurerm_resource_group.example.name
  email_receiver {
    name                    = "example-email"
    email_address           = "example@example.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

data "azurerm_subscription" "primary" {}
