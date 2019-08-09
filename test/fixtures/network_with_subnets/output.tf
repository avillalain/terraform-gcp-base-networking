output "project_id" {
  value = var.project_id
}

output "subnetworks" {
  value = module.network.subnetworks
}

output "network" {
  value = module.network.network
}