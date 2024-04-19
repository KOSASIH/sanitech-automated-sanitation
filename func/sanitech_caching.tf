resource "azurerm_redis_cache" "example" {
  name                = "example-redis"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  capacity            = 2
  family              = "C"
  sku_name           = "Standard"

  redis_configuration {
    maxclients = 1000
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

data "azurerm_subscription" "primary" {}
