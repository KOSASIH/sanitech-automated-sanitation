# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "sanitech_rg" {
  name     = "sanitech-rg"
  location = "East US"
}

# Create a Azure Active Directory group for Sanitech users
resource "azurerm_group" "sanitech_users" {
  name     = "sanitech-users"
  location = azurerm_resource_group.sanitech_rg.location
  resource_group_name = azurerm_resource_group.sanitech_rg.name
}

# Create a Azure Active Directory group for Sanitech administrators
resource "azurerm_group" "sanitech_admins" {
  name     = "sanitech-admins"
  location = azurerm_resource_group.sanitech_rg.location
  resource_group_name = azurerm_resource_group.sanitech_rg.name
}

# Add users to the Sanitech users group
resource "azurerm_group_member" "sanitech_user_member" {
  for_each = toset(var.sanitech_users)
  group_object_id = azurerm_group.sanitech_users.id
  member_object_id = data.azurerm_user.sanitech_user[each.value].id
}

# Add users to the Sanitech administrators group
resource "azurerm_group_member" "sanitech_admin_member" {
  for_each = toset(var.sanitech_admins)
  group_object_id = azurerm_group.sanitech_admins.id
  member_object_id = data.azurerm_user.sanitech_user[each.value].id
}

# Get users from Azure Active Directory
data "azurerm_user" "sanitech_user" {
  for_each = toset(var.sanitech_users)
  user_principal_name = each.value
}

# Define a variable for Sanitech users
variable "sanitech_users" {
  type        = list(string)
  description = "List of Sanitech user email addresses"
  default     = []
}

# Define a variable for Sanitech administrators
variable "sanitech_admins" {
  type        = list(string)
  description = "List of Sanitech administrator email addresses"
  default     = []
}
