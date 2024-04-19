resource "azurerm_site_recovery_site" "example" {
  name                = "example-site"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_site_recovery_protection_container" "example" {
  name                = "example-protection-container"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  site_name           = azurerm_site_recovery_site.example.name
  fabric_name         = "example-fabric"
}

resource "azurerm_site_recovery_protection_policy" "example" {
  name                = "example-protection-policy"
  resource_group_name = azurerm_resource_group.example.name
  site_name           = azurerm_site_recovery_site.example.name

  recovery_frequency = "Weekly"
  retention_policy {
    retention_time_in_hours = 24
  }
}

resource "azurerm_site_recovery_protection_container_mapping" "example" {
  name                = "example-protection-container-mapping"
  protection_container_id = azurerm_site_recovery_protection_container.example.id
  recovery_fabric_id   = azurerm_site_recovery_replication_fabric.example.id
}

resource "azurerm_site_recovery_replication_fabric" "example" {
  name                = "example-replication-fabric"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  site_name           = azurerm_site_recovery_site.example.name
}

resource "azurerm_site_recovery_replication_policy" "example" {
  name                = "example-replication-policy"
  resource_group_name = azurerm_resource_group.example.name
  site_name           = azurerm_site_recovery_site.example.name

  recovery_frequency = "Weekly"
  retention_policy {
    retention_time_in_hours = 24
  }
}

resource "azurerm_site_recovery_replicated_vm" "example" {
  name                = "example-replicated-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = "eastus"
  replication_policy_id = azurerm_site_recovery_replication_policy.example.id
  recovery_vault_id    = azurerm_site_recovery_vault.example.id

  source_virtual_machine_id = azurerm_virtual_machine.example.id
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

resource "azurerm_site_recovery_site" "example" {
  name                = "example-site"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_site_recovery_replication_fabric" "example" {
  name                = "example-replication-fabric"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  site_name           = azurerm_site_recovery_site.example.name
}

resource "azurerm_site_recovery_replication_policy" "example" {
  name                = "example-replication-policy"
  resource_group_name = azurerm_resource_group.example.name
  site_name           = azurerm_site_recovery_site.example.name

  recovery_frequency = "Weekly"
  retention_policy {
    retention_time_in_hours = 24
  }
}

resource "azurerm_site_recovery_protection_container" "example" {
  name                = "example-protection-container"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  site_name           = azurerm_site_recovery_site.example.name
}

resource "azurerm_site_recovery_protection_policy" "example" {
  name                = "example-protection-policy"
  resource_group_name = azurerm_resource_group.example.name
  site_name           = azurerm_site_recovery_site.example.name

  recovery_frequency = "Weekly"
  retention_policy {
    retention_time_in_hours = 24
  }
}

resource "azurerm_site_recovery_protection_container_mapping" "example" {
  name                = "example-protection-container-mapping"
  protection_container_id = azurerm_site_recovery_protection_container.example.id
  recovery_fabric_id   = azurerm_site_recovery_replication_fabric.example.id
}

resource "azurerm_site_recovery_vault" "example" {
  name                = "example-vault"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_machine" "example" {
  name                = "example-vm"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  vm_size             = "Standard_F2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "example-vm"
    admin_username = "exampleadmin"
    admin_password = "ExampleP@ssw0rd1234!"
  }

  network_interface_id = azurerm_network_interface.example.id
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example-ip-configuration"
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
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
