resource "azurerm_virtual_network" "dk-01-vnet-pub" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-vnet-pub"
  address_space       = ["172.16.0.0/16"]

  subnet {
    name           = "dk-01-sub-pub"
    address_prefix = "172.16.0.0/24"
    security_group = azurerm_network_security_group.dk-01-sub-pub-nsg.id
  }

}

resource "azurerm_virtual_network" "dk-01-vnet-priv" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-vnet-priv"
  address_space       = ["172.17.0.0/16"]

  subnet {
    name           = "dk-01-sub-priv"
    address_prefix = "172.17.0.0/24"
    security_group = azurerm_network_security_group.dk-01-sub-priv-nsg.id
  }

  subnet {
    name           = "dk-01-sub-db"
    address_prefix = "172.17.1.0/24"
    security_group = azurerm_network_security_group.dk-01-sub-db-nsg.id
  }

  subnet {
    name           = "dk-01-sub-appg"
    address_prefix = "172.17.2.0/24"
    security_group = azurerm_network_security_group.dk-01-sub-appg-nsg.id
  }

}
