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