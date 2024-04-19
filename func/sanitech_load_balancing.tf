resource "azurerm_public_ip" "example" {
  name                = "example-ip"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "example" {
  name                = "example-lb"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "example-ip"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = "example-pool"
  }

  probe {
    name = "example-probe"

    request_path = "/health"
  }

  load_balancing_rule {
    name                = "example-rule"
    frontend_ip_configuration_name = "example-ip"
    backend_address_pool_name       = "example-pool"
    probe_name                       = "example-probe"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

data "azurerm_subscription" "primary" {}
