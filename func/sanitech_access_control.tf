resource "azurerm_role_assignment" "example" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = data.azurerm_role_definition.example.id
  principal_id       = data.azurerm_client_config.current.object_id
}

data "azurerm_role_definition" "example" {
  name = "Contributor"
}

data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}
