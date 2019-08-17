output "project_id" {
  value = "${var.project_id}"
}

output "network" {
  value = module.network.network
}

output "network_name" {
  value = var.network_name
}

output "description" {
  value = var.description
}
