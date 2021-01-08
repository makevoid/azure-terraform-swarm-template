output "bastion_host_ip" {
  value = azurerm_public_ip.dk-01-bas-ip.ip_address
}

resource "local_file" "output_bastion_ip" {
  filename = "${path.module}/output_bastion_ip.txt"
  content  = azurerm_public_ip.dk-01-bas-ip.ip_address
}

output "app_gateway_ip" {
  value = azurerm_public_ip.dk-01-appg-ip-1.ip_address
}

resource "local_file" "output_app_gateway_ip" {
  filename = "${path.module}/output_app_gateway_ip.txt"
  content  = azurerm_public_ip.dk-01-appg-ip-1.ip_address
}
