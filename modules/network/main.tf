// modules/network/main.tf

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to network resources"
  default     = {}
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the VNet"
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the subnet"
}

variable "ssh_source_ip" {
  type        = string
  description = "CIDR for SSH access to the VM"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-terraform-lab"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "nsg-terraform-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "ssh_inbound" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.ssh_source_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Name of the resource group"
}

output "resource_group_location" {
  value       = azurerm_resource_group.rg.location
  description = "Location of the resource group"
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "ID of the subnet"
}

output "nsg_id" {
  value       = azurerm_network_security_group.vm_nsg.id
  description = "ID of the network security group"
}
