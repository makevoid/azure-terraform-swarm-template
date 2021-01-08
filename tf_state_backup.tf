# TODO: enable for prod

# data "terraform_remote_state" "remote_state" {
#   backend = "azurerm"
#
#   config {
#     storage_account_name = "${var.storage_account_name}"
#     key                  = "${var.key}"
#     container_name       = "${var.container_name}"
#     resource_group_name  = azurerm_resource_group.dk-01-rg.name
#     access_key           = "${var.storage_account_access_key}"
#   }
# }
#
# resource "azurerm_storage_account" "storage-account-tf-backup-1" {
#   name                     = "tfbackup1"
#   resource_group_name      = azurerm_resource_group.dk-01-rg.name
#   location                 = azurerm_resource_group.dk-01-rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }
