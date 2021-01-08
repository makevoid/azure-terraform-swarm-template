terraform {
  backend "local" { }
}

provider "azurerm" {
  version = "~> 2.35.0"
  features {}
}
