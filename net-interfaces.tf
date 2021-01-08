resource "azurerm_network_interface" "dk-01-bas-net-interface" {
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  location            = azurerm_resource_group.dk-01-rg.location
  name                = "dk-01-bas-net-interface"

  ip_configuration {
    name                          = "dk-01-bas-net-interface-ipconfig"
    private_ip_address            = "172.16.0.4"
    primary                       = "true"
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.dk-01-bas-ip.id
    subnet_id                     = tolist(azurerm_virtual_network.dk-01-vnet-pub.subnet)[0].id
  }

  enable_accelerated_networking = "false"
  enable_ip_forwarding          = "false"
}

resource "azurerm_network_interface" "dk-01-vm1-net-interface" {
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  location            = azurerm_resource_group.dk-01-rg.location
  name                = "dk-01-vm1-net-interface"

  ip_configuration {
    name                          = "dk-01-vm1-net-interface-ipconfig"
    private_ip_address            = "172.17.0.4"
    primary                       = "true"
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    subnet_id                     = tolist(azurerm_virtual_network.dk-01-vnet-priv.subnet)[0].id
  }

  enable_accelerated_networking = "false"
  enable_ip_forwarding          = "false"
}

resource "azurerm_network_interface" "dk-01-vm2-net-interface" {
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  location            = azurerm_resource_group.dk-01-rg.location
  name                = "dk-01-vm2-net-interface"

  ip_configuration {
    name                          = "dk-01-vm2-net-interface-ipconfig"
    private_ip_address            = "172.17.0.5"
    primary                       = "true"
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    subnet_id                     = tolist(azurerm_virtual_network.dk-01-vnet-priv.subnet)[0].id
  }

  enable_accelerated_networking = "false"
  enable_ip_forwarding          = "false"
}
