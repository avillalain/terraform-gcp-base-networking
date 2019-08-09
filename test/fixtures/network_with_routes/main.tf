provider "google" {
  version = "~> 2.11.0"
}

module "network" {
  source = "../../../"
  network = {
    name = var.network_name
    routing_mode = "REGIONAL"
    delete_default_routes = false
    description = var.description
  }
  routes = var.routes
}