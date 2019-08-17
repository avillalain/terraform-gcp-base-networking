output "project_id" {
  value = var.project_id
}

output "subnetworks" {
  value = module.network.subnetworks
}

output "network" {
  value = module.network.network
}

output "routes" {
  value = module.network.routes
}

output "network_name" {
  value = var.network_name
}

output "description" {
  value = var.description
}

output "source_routes" {
  value = var.routes
}