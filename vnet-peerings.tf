resource "azurerm_virtual_network_peering" "vnet-peering-1" {
  name                      = "vnet-peering-1"
  resource_group_name       = azurerm_resource_group.dk-01-rg.name
  virtual_network_name      = azurerm_virtual_network.dk-01-vnet-pub.name
  remote_virtual_network_id = azurerm_virtual_network.dk-01-vnet-priv.id
}

resource "azurerm_virtual_network_peering" "vnet-peering-2" {
  name                      = "vnet-peering-2"
  resource_group_name       = azurerm_resource_group.dk-01-rg.name
  virtual_network_name      = azurerm_virtual_network.dk-01-vnet-priv.name
  remote_virtual_network_id = azurerm_virtual_network.dk-01-vnet-pub.id
}
