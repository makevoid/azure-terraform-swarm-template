locals {
  deployer_ssh_key_pub = "ssh-rsa xxxx1" # NOTE: has to be RSA (2048) for Azure
  bastion_ssh_key_pub  = "ssh-rsa xxxx2"
  distro_offer         = "debian-10" # debian ftw
  distro_publisher     = "debian"
  distro_sku           = "10"
  distro_version       = "latest"
}

resource "azurerm_linux_virtual_machine" "dk-01-bas" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-bas"
  computer_name       = "dk-01-bas"
  zone                = "1"
  priority            = "Regular"
  provision_vm_agent  = "true"
  size                = "Standard_DS1_v2"

  admin_username                  = "azureuser"
  allow_extension_operations      = "true"
  disable_password_authentication = "true"
  encryption_at_host_enabled      = "false"
  max_bid_price                   = "-1"
  network_interface_ids           = [azurerm_network_interface.dk-01-bas-net-interface.id]

  admin_ssh_key {
    public_key = local.deployer_ssh_key_pub
    username   = "azureuser"
  }

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = "40"
    name                      = "dk-01-bas-os_disk"
    storage_account_type      = "Standard_LRS"
    write_accelerator_enabled = "false"
  }

  source_image_reference {
    offer     = local.distro_offer
    publisher = local.distro_publisher
    sku       = local.distro_sku
    version   = local.distro_version
  }

}

# swarm vm #1
resource "azurerm_linux_virtual_machine" "dk-01-vm1" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-vm1"
  computer_name       = "dk-01-vm1"
  zone                = "1"
  priority            = "Regular"
  provision_vm_agent  = "true"
  size                = "Standard_D2s_v3"

  admin_username                  = "azureuser"
  allow_extension_operations      = "true"
  disable_password_authentication = "true"
  encryption_at_host_enabled      = "false"
  max_bid_price                   = "-1"
  network_interface_ids           = [azurerm_network_interface.dk-01-vm1-net-interface.id]

  admin_ssh_key {
    public_key = local.bastion_ssh_key_pub
    username   = "azureuser"
  }

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = "80"
    name                      = "dk-01-vm1-os_disk"
    storage_account_type      = "Premium_LRS"
    write_accelerator_enabled = "false"
  }

  source_image_reference {
    offer     = local.distro_offer
    publisher = local.distro_publisher
    sku       = local.distro_sku
    version   = local.distro_version
  }

}


# swarm vm #2
resource "azurerm_linux_virtual_machine" "dk-01-vm2" {
  location            = azurerm_resource_group.dk-01-rg.location
  resource_group_name = azurerm_resource_group.dk-01-rg.name
  name                = "dk-01-vm2"
  computer_name       = "dk-01-vm2"
  zone                = "2"
  priority            = "Regular"
  provision_vm_agent  = "true"
  size                = "Standard_D2s_v3"

  admin_username                  = "azureuser"
  allow_extension_operations      = "true"
  disable_password_authentication = "true"
  encryption_at_host_enabled      = "false"
  max_bid_price                   = "-1"
  network_interface_ids           = [azurerm_network_interface.dk-01-vm2-net-interface.id]

  admin_ssh_key {
    public_key = local.bastion_ssh_key_pub
    username   = "azureuser"
  }

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = "80"
    name                      = "dk-01-vm2-os_disk"
    storage_account_type      = "Premium_LRS"
    write_accelerator_enabled = "false"
  }

  source_image_reference {
    offer     = local.distro_offer
    publisher = local.distro_publisher
    sku       = local.distro_sku
    version   = local.distro_version
  }

}
