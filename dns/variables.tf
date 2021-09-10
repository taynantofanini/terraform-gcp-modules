variable "project" {

}

variable "zone_name" {

}

variable "dns_name" {

}

variable "record_set" {
  
  type = map(object({
    name    = string
    type    = string
    rrdatas = string
    ttl     = number

  }))
}
