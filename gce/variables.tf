#global
variable "project" {
  description = "The GCP project of resources"
  type        = string
}

#firewall.tf
variable "firewalls" {
  type = map(object({
    name          = string
    source_ranges = list(string)
    protocol      = string
    ports         = list(string)
    target_tags   = list(string)
  }))
}

#network.tf
variable "network_name" {
  description = "The name of the network"
  type        = string
}

variable "subnets" {
  type = map(object({
    name   = string
    range  = string
    region = string
  }))
}

#vm.tf
variable "vms" {
  type = map(object({
    name         = string
    machine_type = string
    disk_image   = string
    disk_type    = string
    disk_size    = string
    region       = string
    zone         = string
    subnet       = string
  }))
}
# variable "vm_name" {

# }
# variable "machine_type" {

# }
# variable "zone" {

# }
# variable "disk_image" {

# }
# variable "disk_size" {

# }
# variable "disk_type" {

# }
# # variable "region" {

# # }
