#https-lb
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "website-forwarding-rule"
  port_range            = 443
  ip_address            = google_compute_global_address.external-ip-lb.address
  load_balancing_scheme = "EXTERNAL"
  project               = var.project
  target                = google_compute_target_https_proxy.default.self_link
}

resource "google_compute_target_https_proxy" "default" {
  name             = "${lower(var.environment)}-${lower(var.customer_name)}-target-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "www-${lower(var.customer_name)}-com-br"

  managed {
    domains = ["www.${var.cert_dns_name}", var.cert_dns_name]
  }
}

resource "google_compute_url_map" "default" {
  name        = "${lower(var.environment)}-${lower(var.customer_name)}-https"
  description = "managed by terraform"

  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                            = "${lower(var.environment)}-${lower(var.customer_name)}-backend"
  health_checks                   = [google_compute_http_health_check.default.id]
  connection_draining_timeout_sec = 30
  enable_cdn                      = true
  load_balancing_scheme           = "EXTERNAL" #Possible values are EXTERNAL and INTERNAL_SELF_MANAGED.
  port_name                       = "http"
  protocol                        = "HTTP" #Possible values are HTTP, HTTPS, HTTP2, TCP, SSL, and GRPC.

  cdn_policy {
    cache_mode                   = "CACHE_ALL_STATIC"
    default_ttl                  = 3600
    client_ttl                   = 3600
    max_ttl                      = 86400
    signed_url_cache_max_age_sec = 7200
  }

  backend {
    group = google_compute_instance_group.webservers.id
  }
}

resource "google_compute_http_health_check" "default" {
  name                = "hc-http-80"
  request_path        = "/"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}

resource "google_compute_instance_group" "webservers" {
  name        = "${lower(var.environment)}-${lower(var.customer_name)}-ig"
  description = "managed-by-terraform"
  zone        = "us-east1-b"

  instances = var.instances

  named_port {
    name = "http"
    port = "80"
  }

}

resource "google_compute_global_address" "external-ip-lb" {
  name = "lb-external"
}

resource "google_compute_firewall" "firewall-lb" {
  network       = var.network
  description   = "managed-by-terraform"
  name          = "allow-lb-health-check"
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

}

#http-lb

resource "google_compute_url_map" "lb-redir" {
  name        = "${lower(var.environment)}-${lower(var.customer_name)}-redir"
  description = "managed by terraform"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT" // 301 redirect
    strip_query            = false
    https_redirect         = true // this is the magic
  }

}

resource "google_compute_target_http_proxy" "http-proxy" {
  name    = "${lower(var.environment)}-${lower(var.customer_name)}-target-proxy-http"
  url_map = google_compute_url_map.lb-redir.id
}

resource "google_compute_global_forwarding_rule" "http-redirect" {
  name       = "http-redirect"
  target     = google_compute_target_http_proxy.http-proxy.self_link
  ip_address = google_compute_global_address.external-ip-lb.address
  port_range = "80"
}
