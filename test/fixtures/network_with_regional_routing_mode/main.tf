provider "google" {
  version = "~> 2.11.0"
}

module "network" {
  source = "../../../"
  network = {
    name = var.network_name
    routing_mode = var.routing_mode
    delete_default_routes = false
    description = var.description
  }
}