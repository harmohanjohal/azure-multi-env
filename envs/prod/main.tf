terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-state"
    storage_account_name = "tfstateharmohan123"
    container_name       = "tfstate"
    key                  = "azure-multi-env-prod.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source = "../../modules/network"

  location                = var.location
  resource_group_name     = "rg-terraform-multi-prod"
  vnet_address_space      = ["10.10.0.0/16"]
  subnet_address_prefixes = ["10.10.1.0/24"]
  ssh_source_ip           = var.ssh_source_ip

  tags = {
    environment = "prod"
    project     = "azure-multi-env"
    owner       = "harmohan"
  }
}

module "compute_web" {
  source = "../../modules/compute"

  location            = module.network.resource_group_location
  resource_group_name = module.network.resource_group_name
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id

  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key

  vm_name          = "vm-terraform-web-prod"
  enable_public_ip = false
}

module "compute_worker" {
  source = "../../modules/compute"

  location            = module.network.resource_group_location
  resource_group_name = module.network.resource_group_name
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id

  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key

  vm_name          = "vm-terraform-worker-prod"
  enable_public_ip = false
}
