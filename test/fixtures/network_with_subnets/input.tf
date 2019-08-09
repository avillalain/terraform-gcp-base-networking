variable "network_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "description" {
  type = string
}

variable "subnetworks" {
  type = list(object({
    name = string
    cidr_range = string
    private_access = bool
    region = string
    description = string
    enable_flow_logs = bool
    secondary_ranges = list(object({
      name = string
      cidr_range = string
    }))
  }))
}