resource "azurerm_monitor_autoscale_setting" "example" {
  name                = "example-autoscale-setting"
  resource_group_name = azurerm_resource_group.example.name
  location            = "eastus"
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.example.id

  profile {
    name = "example-profile"

    capacity {
      minimum = 1
      maximum = 10default = 1
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type     = "ChangeCount"
        value    = "1"
        cooldown = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 50
      }

      scale_action {
        direction = "Decrease"
        type     = "ChangeCount"
        value    = "1"
        cooldown = "PT5M"
      }
    }
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  upgrade_policy_mode = "Automatic"

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = "example-vm"
    admin_username       = "exampleadmin"
    admin_password       = "ExampleP@ssw0rd1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "example-network-profile"
    primary = true

    ip_configuration {
      name                          = "example-ip-configuration"
      subnet_id                     = data.azurerm_subnet.example.id
      load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.example.id]
      primary = true
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

data "azurerm_subnet" "example" {
  name                 = "example-subnet"
  virtual_network_name = "example-vnet"
  resource_group_name  = "example-resources"
}

data "azurerm_subscription" "primary" {}
