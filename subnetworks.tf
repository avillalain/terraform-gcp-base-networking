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

locals {
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
}
