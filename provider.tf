terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }

  cloud {
    organization = "d2click"
    workspaces {
      name = "AVD-FSLogix-Without-Domain-Controllers"
    }
  }
}

provider "azurerm" {
  features {}
}