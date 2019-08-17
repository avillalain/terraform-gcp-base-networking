variable "network" {
  type = object({
    name                  = string
    routing_mode          = string
    delete_default_routes = bool
    description           = string
  })
  description = "The configuration options for a network"
}

variable "subnetworks" {
  type = list(object({
    name             = string
    description      = string
    cidr_range       = string
    private_access   = bool
    region           = string
    enable_flow_logs = bool
    secondary_ranges = list(object({
      name       = string
      cidr_range = string
    }))
  }))
  default     = []
  description = "the list of subnets being created"
}

variable "routes" {
  type = list(object({
    name              = string
    description       = string
    tags              = list(string)
    destination_range = string
    next_hop_type     = string
    next_hop          = string
    priority          = string
  }))
  default     = []
  description = "the list of routes being created"
}
