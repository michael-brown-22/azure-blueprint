# Common Outputs

variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
  default     = "myorg"
}

variable "root_name" {
  type        = string
  description = "Sets the value used for the \"intermediate root\" management group display name."
  default     = "My Organization"
}

variable "primary_location" {
  type        = string
  description = "Sets the location for \"primary\" resources to be created in."
  default     = "northeurope"
}

variable "secondary_location" {
  type        = string
  description = "Sets the location for \"secondary\" resources to be created in."
  default     = ""
}

###################################################################################################################################################################################################

# Management Outputs

output "configuration" {
  description = "Configuration settings for the \"management\" resources."
  value       = local.configure_management_resources
}

output "subscription_id" {
  description = "Subscription ID for the \"management\" resources."
  value       = var.subscription_id_management
}

###################################################################################################################################################################################################

# Connectivity Outputs

output "configuration" {
  description = "Configuration settings for the \"connectivity\" resources."
  value       = local.configure_connectivity_resources
}

output "subscription_id" {
  description = "Subscription ID for the \"connectivity\" resources."
  value       = var.subscription_id_connectivity
}

###################################################################################################################################################################################################

# Core Outputs

###################################################################################################################################################################################################