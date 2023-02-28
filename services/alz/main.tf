# Configure Terraform to set the required AzureRM provider
# version and features{} block

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "tstate"
  #   storage_account_name = "tstate7441"
  #   container_name       = "tstate"
  #   key                  = "terraform.tfstate"
  # }
}

# Define the provider configuration

provider "azurerm" {
  features {}
}


# Get the current client configuration from the AzureRM provider

data "azurerm_client_config" "current" {}

# Logic to handle 1-3 platform subscriptions as available

# Declare the Azure landing zones Terraform module
# and provide the connectivity configuration.

module "alz" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "3.1.2"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # Base module configuration settings
  root_parent_id = var.root_parent_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

#  Common
  default_tags = var.default_tags
  
#  Management
  # Configuration settings for management resources
  deploy_management_resources    = var.deploy_management_resources
  configure_management_resources = var.configure_management_resources
  subscription_id_management     = var.subscription_id_management

#  Connectivity
  # Configuration settings for connectivity resources
  deploy_connectivity_resources    = var.deploy_connectivity_resources
  configure_connectivity_resources = var.configure_connectivity_resources
  subscription_id_connectivity     = var.subscription_id_connectivity

#  Core
  # Enable creation of the core management group hierarchy
  # and additional custom_landing_zones
  deploy_core_landing_zones = var.deploy_core_landing_zones
  custom_landing_zones      = var.custom_landing_zones

  # Configuration settings for identity resources is
  # bundled with core as no resources are actually created
  # for the identity subscription
  deploy_identity_resources    = var.deploy_identity_resources
  configure_identity_resources = var.configure_identity_resources
  subscription_id_identity     = var.subscription_id_identity

}