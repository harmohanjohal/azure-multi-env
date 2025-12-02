variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "admin_username" {
  description = "Admin username for the Linux VM"
  type        = string
  default     = "vmadmin"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the admin user"
  type        = string
}

variable "ssh_source_ip" {
  description = "CIDR for SSH access (e.g. your_public_ip/32)"
  type        = string
  default     = "0.0.0.0/0"
}
