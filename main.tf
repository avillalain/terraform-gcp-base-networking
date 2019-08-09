resource "google_compute_network" "network" {
    name = var.network["name"]
    auto_create_subnetworks = false
    routing_mode = var.network["routing_mode"]
    delete_default_routes_on_create = var.network["delete_default_routes"]
    description = var.network["description"]
}

resource "google_compute_subnetwork" "subnetworks" {
    count = length(var.subnetworks)
    name = var.subnetworks[count.index]["name"]
    description = var.subnetworks[count.index]["description"]
    network = google_compute_network.network.self_link
    region = var.subnetworks[count.index]["region"]
    ip_cidr_range = var.subnetworks[count.index]["cidr_range"]
    private_ip_google_access = var.subnetworks[count.index]["private_access"]
    enable_flow_logs = var.subnetworks[count.index]["enable_flow_logs"]

    dynamic "secondary_ip_range" {
        for_each = var.subnetworks[count.index]["secondary_ranges"]
        content {
            range_name = lookup(secondary_ip_range.value, "name", null)
            ip_cidr_range = lookup(secondary_ip_range.value, "cidr_range", null)
        }
    }
}

resource "google_compute_route" "routes" {
    count = length(var.routes)
    dest_range = lookup(var.routes[count.index], "destination_range", "")
    name = lookup(var.routes[count.index], "name", "")
    network = google_compute_network.network.self_link
    description = lookup(var.routes[count.index], "description", "")
    priority = lookup(var.routes[count.index], "priority", "")
    tags = lookup(var.routes[count.index], "tags", [])
    next_hop_gateway = lookup(var.routes[count.index], "next_hop_type", null) == "DEFAULT" ? lookup(var.routes[count.index], "next_hop", null) : null
    next_hop_instance = lookup(var.routes[count.index], "next_hop_type", null) == "INSTANCE" ? lookup(var.routes[count.index], "next_hop", null) : null
    next_hop_ip = lookup(var.routes[count.index], "next_hop_type", null) == "IP_ADDR" ? lookup(var.routes[count.index], "next_hop", null) : null
    next_hop_vpn_tunnel = lookup(var.routes[count.index], "next_hop_type", null) == "VPN" ? lookup(var.routes[count.index], "next_hop", null) : null
}

locals {
    network = {
        self_link = google_compute_network.network.self_link
        name = google_compute_network.network.name
        routing_mode = google_compute_network.network.routing_mode
        delete_default_routes = google_compute_network.network.delete_default_routes_on_create
        description = var.network["description"]
    }
    subnetworks = [for subnetwork in google_compute_subnetwork.subnetworks: {
            self_link = subnetwork.self_link
            name = subnetwork.name
            cidr_range = subnetwork.ip_cidr_range
            region = subnetwork.region
            private_access = subnetwork.private_ip_google_access
            description = subnetwork.description
            enable_flow_logs = subnetwork.enable_flow_logs
            secondary_ranges = [for secondary_range in subnetwork.secondary_ip_range: {
                name = secondary_range.range_name
                cidr_range = secondary_range.ip_cidr_range
            }]
        }
    ]
    routes = [for route in google_compute_route.routes: {
            self_link = route.self_link
            name = route.name
            description = route.description
            tags = route.tags
            destination_range = route.dest_range
            next_hop_type = length(route.next_hop_gateway) != 0 ? "DEFAULT" : length(route.next_hop_instance) != 0 ? "INSTANCE" : length(route.next_hop_ip) != 0 ? "IP_ADDR" : "VPN"
            next_hop = coalesce(route.next_hop_gateway, route.next_hop_instance, route.next_hop_ip, route.next_hop_vpn_tunnel)
            priority = route.priority
        }
    ]
}