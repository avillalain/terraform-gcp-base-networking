resource "google_compute_network" "network" {
    name = var.network["name"]
    auto_create_subnetworks = false
    routing_mode = var.network["routing_mode"]
    delete_default_routes_on_create = var.network["delete_default_routes"]
    description = var.network["description"]
}

locals {
    network = {
        self_link = google_compute_network.network.self_link
        name = google_compute_network.network.name
        routing_mode = google_compute_network.network.routing_mode
        delete_default_routes = google_compute_network.network.delete_default_routes_on_create
        description = var.network["description"]
    }
}