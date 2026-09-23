terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "container-instance-redis" {
  source = "../../modules/container-instance-redis"

  name_prefix = "locally-example-redis"
  location    = "berlin"
  tags = {
    ProvisionedVia = "Terraform"
  }
}
