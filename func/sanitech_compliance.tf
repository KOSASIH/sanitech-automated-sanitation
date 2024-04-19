resource "azurerm_policy_assignment" "example" {
  name                = "example-policy-assignment"
  scope              = data.azurerm_subscription.primary.id
  policy_definition_id = data.azurerm_policy_definition.example.id
}

data "azurerm_policy_definition" "example" {
  name = "audit-vm-extensions-policy"
}

data "azurerm_subscription" "primary" {}
