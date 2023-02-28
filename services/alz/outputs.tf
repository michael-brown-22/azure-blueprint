# Common Outputs


###################################################################################################################################################################################################

# Management Outputs

output "management_configuration" {
  description = "Configuration settings for the \"management\" resources."
  value       = var.configure_management_resources
}

output "management_subscription_id" {
  description = "Subscription ID for the \"management\" resources."
  value       = var.subscription_id_management
}

###################################################################################################################################################################################################

# Connectivity Outputs

output "connectivity_configuration" {
  description = "Configuration settings for the \"connectivity\" resources."
  value       = var.configure_connectivity_resources
}

output "connectivity_subscription_id" {
  description = "Subscription ID for the \"connectivity\" resources."
  value       = var.subscription_id_connectivity
}

###################################################################################################################################################################################################

# Core Outputs

###################################################################################################################################################################################################