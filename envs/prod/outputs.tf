output "resource_group_name" {
  description = "Name of the prod resource group"
  value       = module.network.resource_group_name
}

output "web_vm_public_ip" {
  description = "Public IP of the prod web VM"
  value       = module.compute_web.vm_public_ip
}

output "worker_vm_public_ip" {
  description = "Public IP of the prod worker VM"
  value       = module.compute_worker.vm_public_ip
}

output "web_ssh_command" {
  description = "SSH command for the prod web VM (if it has a public IP)"
  value       = module.compute_web.vm_public_ip != null ? "ssh ${var.admin_username}@${module.compute_web.vm_public_ip}" : null
}

output "worker_ssh_command" {
  description = "SSH command for the prod worker VM (if it has a public IP)"
  value       = module.compute_worker.vm_public_ip != null ? "ssh ${var.admin_username}@${module.compute_worker.vm_public_ip}" : null
}
