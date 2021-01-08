resource "azurerm_application_gateway" "dk-01-appg" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-appg"
  enable_http2        = true

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 10
  }

  gateway_ip_configuration {
    name      = "dk-01-appg-ip-conf-1"
    subnet_id = tolist(azurerm_virtual_network.dk-01-vnet-priv.subnet)[2].id
  }

  frontend_port {
    name = "dk-01-appg-fe-port-1"
    port = 80
  }

  frontend_port {
    name = "dk-01-appg-fe-port-2"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "dk-01-appg-fe-ip-conf-1"
    public_ip_address_id = azurerm_public_ip.dk-01-appg-ip-1.id
  }

  backend_address_pool {
    name = "dk-01-appg-be-pool-1"
  }

  backend_http_settings {
    name                  = "dk-01-appg-http-settings-1"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    probe_name            = "dk-01-appg-hcprobe-1"
    protocol              = "Http"
    request_timeout       = 240 # NOTE: set to 2 minutes - this can be tweaked (max value is 24h :D)
  }

  http_listener {
    name                           = "dk-01-appg-http-list-1"
    frontend_ip_configuration_name = "dk-01-appg-fe-ip-conf-1"
    frontend_port_name             = "dk-01-appg-fe-port-1"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "dk-01-appg-http-list-2"
    frontend_ip_configuration_name = "dk-01-appg-fe-ip-conf-1"
    frontend_port_name             = "dk-01-appg-fe-port-2"
    protocol                       = "Https"
    ssl_certificate_name           = "star-data-run3"
  }

  request_routing_rule {
    name                       = "dk-01-appg-rr-rule-1"
    rule_type                  = "Basic"
    http_listener_name         = "dk-01-appg-http-list-1"
    backend_address_pool_name  = "dk-01-appg-be-pool-1"
    backend_http_settings_name = "dk-01-appg-http-settings-1"
  }

  request_routing_rule {
    name                       = "dk-01-appg-rr-rule-2"
    rule_type                  = "Basic"
    http_listener_name         = "dk-01-appg-http-list-2"
    backend_address_pool_name  = "dk-01-appg-be-pool-1"
    backend_http_settings_name = "dk-01-appg-http-settings-1"
  }

  probe {
    name                = "dk-01-appg-hcprobe-1"
    host                = "127.0.0.1"
    path                = "/api/health"
    interval            = 3
    timeout             = 3
    unhealthy_threshold = 2
    protocol            = "Http"
    match {
      status_code = ["200"]
      # body = "" # optional - validate the healthcheck
    }
  }

  ssl_certificate {
    name     = "cert-name-1"
    data     = "xxx"
    password = "12312312312312"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "dk-01-appg-be-pool-assoc-vm1" {
  network_interface_id    = azurerm_network_interface.dk-01-vm1-net-interface.id
  ip_configuration_name   = azurerm_network_interface.dk-01-vm1-net-interface.ip_configuration[0].name
  backend_address_pool_id = azurerm_application_gateway.dk-01-appg.backend_address_pool[0].id
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "dk-01-appg-be-pool-assoc-vm2" {
  network_interface_id    = azurerm_network_interface.dk-01-vm2-net-interface.id
  ip_configuration_name   = azurerm_network_interface.dk-01-vm2-net-interface.ip_configuration[0].name
  backend_address_pool_id = azurerm_application_gateway.dk-01-appg.backend_address_pool[0].id
}
