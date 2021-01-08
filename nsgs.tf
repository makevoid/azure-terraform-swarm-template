resource "azurerm_network_security_group" "dk-01-sub-pub-nsg" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-sub-pub-nsg"

  security_rule {
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "Internet"
    destination_port_range     = "22"
    name                       = "SSH"
    protocol                   = "TCP"
    priority                   = "100"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_network_security_group" "dk-01-sub-priv-nsg" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-sub-priv-nsg"
}

resource "azurerm_network_security_group" "dk-01-sub-db-nsg" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-sub-db-nsg"
}

resource "azurerm_network_security_group" "dk-01-sub-appg-nsg" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-sub-appg-nsg"

  security_rule {
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "22"
    name                       = "SSH"
    protocol                   = "TCP"
    priority                   = "100"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "Internet"
    destination_port_range     = "80"
    name                       = "HTTP"
    protocol                   = "*"
    priority                   = "200"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "Internet"
    destination_port_range     = "443"
    name                       = "HTTPS"
    protocol                   = "*"
    priority                   = "300"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "2377"
    name                       = "Swarm_2377"
    protocol                   = "TCP"
    priority                   = "400"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "4789"
    name                       = "Swarm_4789"
    protocol                   = "UDP"
    priority                   = "500"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "7946"
    name                       = "Swarm_7946"
    protocol                   = "*"
    priority                   = "600"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "GatewayManager"
    destination_port_range     = "65200-65535" # these ports are locked down by Azure certificates
    name                       = "appg-management"
    protocol                   = "TCP"
    priority                   = "1100"
    source_port_range          = "*"
    destination_address_prefix = "*"
  }
}
