resource "azurerm_public_ip" "dk-01-bas-ip" {
  location                = azurerm_resource_group.dk-01-rg.location
  resource_group_name     = azurerm_resource_group.dk-01-rg.name
  allocation_method       = "Static"
  ip_version              = "IPv4"
  sku                     = "Standard"
  name                    = "dk-01-bas-ip"
  zones                   = ["1"]
  idle_timeout_in_minutes = "4"
}

resource "azurerm_public_ip" "dk-01-appg-ip-1" {
  location                = azurerm_resource_group.dk-01-rg.location
  resource_group_name     = azurerm_resource_group.dk-01-rg.name
  allocation_method       = "Static"
  ip_version              = "IPv4"
  sku                     = "Standard"
  name                    = "dk-01-appg-ip-1"
  zones                   = ["1"]
  idle_timeout_in_minutes = "4"
}
