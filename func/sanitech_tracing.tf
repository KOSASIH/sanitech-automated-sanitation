resource "azurerm_application_insights" "example" {
  name                = "example-app-insights"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

data "azurerm_subscription" "primary" {}
