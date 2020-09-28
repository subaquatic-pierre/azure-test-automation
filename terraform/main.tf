provider "azurerm" {
  version         = "~> 2.29.0"
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "cicdtestautomation"
    container_name       = "cicdtestautomation"
    key                  = "cicdtestautomation"
    access_key           = "2AF1vRW9lGqLaiK79jE44hJypgrhnrDDyDr8vRRCMvtQpvlRJG2MbEnKfYHF68jN+wM0GJgcqZx2ws6W+B8FOQ=="
  }
}

module "resource_group" {
  source         = "./modules/resource_group"
  resource_group = "${var.resource_group}"
  location       = "${var.location}"
}

module "network" {
  source               = "./modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${module.resource_group.resource_group_name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source              = "./modules/networksecuritygroup"
  location            = "${var.location}"
  application_type    = "${var.application_type}"
  resource_type       = "NSG"
  resource_group      = "${module.resource_group.resource_group_name}"
  subnet_id           = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}

module "appservice" {
  source           = "./modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${module.resource_group.resource_group_name}"
}

module "publicip" {
  source           = "./modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${module.resource_group.resource_group_name}"
}

module "vm" {
  source         = "./modules/vm"
  name           = "ci-cd-test-automation"
  location       = "${var.location}"
  subnet_id      = module.network.subnet_id_test
  resource_group = "${module.resource_group.resource_group_name}"
  public_ip      = module.publicip.public_ip_address_id
}
