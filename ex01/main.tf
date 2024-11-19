provider "azurerm" {
  features {}
  subscription_id = "a6c46565-0203-40d4-9199-78dd615c778e"
}

resource "azurerm_resource_group" "rg1" {
  name     = "rg1-S2"
  location = "Canada Central"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-S2"
  address_space       = ["192.168.0.0/19"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-S2"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-S2"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

# Generate a unique DNS label using random_id to avoid DNS record in use errors
resource "random_id" "dns_label" {
  byte_length = 8
}

# Public IP Address
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                  = "Standard"
  
  # Use random_id for uniqueness
  domain_name_label   = "myvm-public-ip-${random_id.dns_label.hex}"
}

# Network Interface for Linux VM
resource "azurerm_network_interface" "nic_linux" {
  name                = "nic-linux-vm"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "ipconfig-linux"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id  # Associate Public IP
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = "linux-vm"
  resource_group_name             = azurerm_resource_group.rg1.name
  location                        = azurerm_resource_group.rg1.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "Password@123" # Replace with secure credentials
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic_linux.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "solvedevops1643693563360"
    offer     = "rocky-linux-9"
    sku       = "plan001"
    version   = "latest"
  }

  plan {
    name      = "plan001"
    publisher = "solvedevops1643693563360"
    product   = "rocky-linux-9"
  }

  custom_data = base64encode(file("user-data.sh"))  # Ensure this script exists and is base64 encoded
}

# Output Public IP Address
output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}
