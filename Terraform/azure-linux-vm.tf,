terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "security_lab" {
  name     = "rg-security-compliance"
  location = "East US"
}

resource "azurerm_virtual_network" "security_lab" {
  name                = "vnet-security-compliance"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.security_lab.location
  resource_group_name = azurerm_resource_group.security_lab.name
}

resource "azurerm_subnet" "workload" {
  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.security_lab.name
  virtual_network_name = azurerm_virtual_network.security_lab.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_network_interface" "linux_vm" {
  name                = "nic-security-linux-vm"
  location            = azurerm_resource_group.security_lab.location
  resource_group_name = azurerm_resource_group.security_lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.workload.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = "security-compliance-linux-vm"
  resource_group_name = azurerm_resource_group.security_lab.name
  location            = azurerm_resource_group.security_lab.location
  size                = "Standard_B1s"

  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.linux_vm.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "lab"
    Purpose     = "security-compliance"
  }
}
