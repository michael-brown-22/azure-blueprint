# Use variables to customize the deployment

variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
  default     = "myorg"
}

variable "root_name" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
  default     = ""
}

variable "primary_location" {
  type        = string
  description = "Sets the location for \"primary\" resources to be created in."
  default     = "northeurope"
}

variable "management_resources" {
  type = bool
  default = false
}

variable "custom_landing_zones" {
  type        = any
  description = "If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups."
  default     = {}

  validation {
    condition     = can([for k in keys(var.custom_landing_zones) : regex("^[a-zA-Z0-9-]{2,36}$", k)]) || length(keys(var.custom_landing_zones)) == 0
    error_message = "The custom_landing_zones keys must be between 2 to 36 characters long and can only contain lowercase letters, numbers and hyphens."
  }
}

# variable "subscription_id_management" {
#   type        = string
#   description = "Subscription ID to use for \"management\" resources."
# }

variable "email_security_contact" {
  type        = string
  description = "Set a custom value for the security contact email address."
  default     = "test.user@replace_me"
}

variable "log_retention_in_days" {
  type        = number
  description = "Set a custom value for how many days to store logs in the Log Analytics workspace."
  default     = 30
}

variable "management_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"management\" resources."
  default = {
    deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
    demo_type  = "Deploy management resources using multiple module declarations"
  }
}

variable "secondary_location" {
  type        = string
  description = "Sets the location for \"secondary\" resources to be created in."
  default     = "westeurope"
}

# variable "subscription_id_connectivity" {
#   type        = string
#   description = "Subscription ID to use for \"connectivity\" resources."
# }

variable "enable_ddos_protection" {
  type        = bool
  description = "Controls whether to create a DDoS Network Protection plan and link to hub virtual networks."
  default     = false
}

variable "connectivity_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"connectivity\" resources."
  default = {
    deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
    demo_type  = "Deploy connectivity resources using multiple module declarations"
  }
}


variable "configure_management_resources" {
  type = object({
    settings = optional(object({
      log_analytics = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          retention_in_days                                 = optional(number, 30)
          enable_monitoring_for_vm                          = optional(bool, true)
          enable_monitoring_for_vmss                        = optional(bool, true)
          enable_solution_for_agent_health_assessment       = optional(bool, true)
          enable_solution_for_anti_malware                  = optional(bool, true)
          enable_solution_for_change_tracking               = optional(bool, true)
          enable_solution_for_service_map                   = optional(bool, true)
          enable_solution_for_sql_assessment                = optional(bool, true)
          enable_solution_for_sql_vulnerability_assessment  = optional(bool, true)
          enable_solution_for_sql_advanced_threat_detection = optional(bool, true)
          enable_solution_for_updates                       = optional(bool, true)
          enable_solution_for_vm_insights                   = optional(bool, true)
          enable_sentinel                                   = optional(bool, true)
        }), {})
      }), {})
      security_center = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          email_security_contact             = optional(string, "security_contact@replace_me")
          enable_defender_for_app_services   = optional(bool, true)
          enable_defender_for_arm            = optional(bool, true)
          enable_defender_for_containers     = optional(bool, true)
          enable_defender_for_dns            = optional(bool, true)
          enable_defender_for_key_vault      = optional(bool, true)
          enable_defender_for_oss_databases  = optional(bool, true)
          enable_defender_for_servers        = optional(bool, true)
          enable_defender_for_sql_servers    = optional(bool, true)
          enable_defender_for_sql_server_vms = optional(bool, true)
          enable_defender_for_storage        = optional(bool, true)
        }), {})
      }), {})
    }), {})
    location = optional(string, "")
    tags     = optional(any, {})
    advanced = optional(any, {})
  })
  description = "If specified, will customize the \"Management\" landing zone settings and resources."
  default = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                                 = 30
          enable_monitoring_for_vm                          = true
          enable_monitoring_for_vmss                        = true
          enable_solution_for_agent_health_assessment       = true
          enable_solution_for_anti_malware                  = true
          enable_solution_for_change_tracking               = true
          enable_solution_for_service_map                   = true
          enable_solution_for_sql_assessment                = true
          enable_solution_for_sql_vulnerability_assessment  = true
          enable_solution_for_sql_advanced_threat_detection = true
          enable_solution_for_updates                       = true
          enable_solution_for_vm_insights                   = true
          enable_sentinel                                   = true
        }
      }
      security_center = {
        enabled = true
        config = {
          email_security_contact             = "security_contact@replace_me"
          enable_defender_for_app_services   = true
          enable_defender_for_arm            = true
          enable_defender_for_containers     = true
          enable_defender_for_dns            = true
          enable_defender_for_key_vault      = true
          enable_defender_for_oss_databases  = true
          enable_defender_for_servers        = true
          enable_defender_for_sql_servers    = true
          enable_defender_for_sql_server_vms = true
          enable_defender_for_storage        = true
        }
      }
    }
  }
}

variable "subscription_id_management" {
  
}

# variable "configure_connectivity_resources" {
#   type        = map(string)
#   description = "Config map for management resources."
#   default     = {}
# }

# variable "deploy_connectivity_resources" {
#   type        = string
#   description = "default value for deploy_connectivity_resources."
#   default     = "false"
# }

variable "default_tags" {
  type        = map(string)
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default     = {}
}