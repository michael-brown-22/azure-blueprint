# Common Variables
# used for all capabilities deployment

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

# Management Variables
# used for the management deployment

variable "subscription_id_management" {
  type        = string
  description = "Subscription ID to use for \"management\" resources."
}

variable "email_security_contact" {
  type        = string
  description = "Set a custom value for the security contact email address."
  default     = "test.user@replace_me"
}

variable "log_retention_in_days" {
  type        = number
  description = "Set a custom value for how many days to store logs in the Log Analytics workspace."
  default     = 60
}

variable "management_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"management\" resources."
  default = {
    deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
    demo_type  = "Deploy management resources using multiple module declarations"
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

###################################################################################################################################################################################################

# Connectivity Variables
# used for the connectivity deployment

variable "connectivity_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"connectivity\" resources."
  default = {
    deployedBy = "terraform/azure/caf-enterprise-scale/examples/l400-multi"
    demo_type  = "Deploy connectivity resources using multiple module declarations"
  }
}

variable "subscription_id_connectivity" {
  type        = string
  description = "Subscription ID to use for \"connectivity\" resources."
}

variable "configure_connectivity_resources" {
  type = object({
    settings = optional(object({
      hub_networks = optional(list(
        object({
          enabled = optional(bool, true)
          config = object({
            address_space                = list(string)
            location                     = optional(string, "")
            link_to_ddos_protection_plan = optional(bool, false)
            dns_servers                  = optional(list(string), [])
            bgp_community                = optional(string, "")
            subnets = optional(list(
              object({
                name                      = string
                address_prefixes          = list(string)
                network_security_group_id = optional(string, "")
                route_table_id            = optional(string, "")
              })
            ), [])
            virtual_network_gateway = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                address_prefix           = optional(string, "")
                gateway_sku_expressroute = optional(string, "")
                gateway_sku_vpn          = optional(string, "")
                advanced_vpn_settings = optional(object({
                  enable_bgp                       = optional(bool, null)
                  active_active                    = optional(bool, null)
                  private_ip_address_allocation    = optional(string, "")
                  default_local_network_gateway_id = optional(string, "")
                  vpn_client_configuration = optional(list(
                    object({
                      address_space = list(string)
                      aad_tenant    = optional(string, null)
                      aad_audience  = optional(string, null)
                      aad_issuer    = optional(string, null)
                      root_certificate = optional(list(
                        object({
                          name             = string
                          public_cert_data = string
                        })
                      ), [])
                      revoked_certificate = optional(list(
                        object({
                          name             = string
                          public_cert_data = string
                        })
                      ), [])
                      radius_server_address = optional(string, null)
                      radius_server_secret  = optional(string, null)
                      vpn_client_protocols  = optional(list(string), null)
                      vpn_auth_types        = optional(list(string), null)
                    })
                  ), [])
                  bgp_settings = optional(list(
                    object({
                      asn         = optional(number, null)
                      peer_weight = optional(number, null)
                      peering_addresses = optional(list(
                        object({
                          ip_configuration_name = optional(string, null)
                          apipa_addresses       = optional(list(string), null)
                        })
                      ), [])
                    })
                  ), [])
                  custom_route = optional(list(
                    object({
                      address_prefixes = optional(list(string), [])
                    })
                  ), [])
                }), {})
              }), {})
            }), {})
            azure_firewall = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                address_prefix                = optional(string, "")
                enable_dns_proxy              = optional(bool, true)
                dns_servers                   = optional(list(string), [])
                sku_tier                      = optional(string, "Standard")
                base_policy_id                = optional(string, "")
                private_ip_ranges             = optional(list(string), [])
                threat_intelligence_mode      = optional(string, "Alert")
                threat_intelligence_allowlist = optional(list(string), [])
                availability_zones = optional(object({
                  zone_1 = optional(bool, true)
                  zone_2 = optional(bool, true)
                  zone_3 = optional(bool, true)
                }), {})
              }), {})
            }), {})
            spoke_virtual_network_resource_ids      = optional(list(string), [])
            enable_outbound_virtual_network_peering = optional(bool, false)
            enable_hub_network_mesh_peering         = optional(bool, false)
          })
        })
      ), [])
      vwan_hub_networks = optional(list(
        object({
          enabled = optional(bool, true)
          config = object({
            address_prefix = string
            location       = string
            sku            = optional(string, "")
            routes = optional(list(
              object({
                address_prefixes    = list(string)
                next_hop_ip_address = string
              })
            ), [])
            expressroute_gateway = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                scale_unit = optional(number, 1)
              }), {})
            }), {})
            vpn_gateway = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                bgp_settings = optional(list(
                  object({
                    asn         = number
                    peer_weight = number
                    instance_0_bgp_peering_address = optional(list(
                      object({
                        custom_ips = list(string)
                      })
                    ), [])
                    instance_1_bgp_peering_address = optional(list(
                      object({
                        custom_ips = list(string)
                      })
                    ), [])
                  })
                ), [])
                routing_preference = optional(string, "Microsoft Network")
                scale_unit         = optional(number, 1)
              }), {})
            }), {})
            azure_firewall = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                enable_dns_proxy              = optional(bool, true)
                dns_servers                   = optional(list(string), [])
                sku_tier                      = optional(string, "Standard")
                base_policy_id                = optional(string, "")
                private_ip_ranges             = optional(list(string), [])
                threat_intelligence_mode      = optional(string, "Alert")
                threat_intelligence_allowlist = optional(list(string), [])
                availability_zones = optional(object({
                  zone_1 = optional(bool, true)
                  zone_2 = optional(bool, true)
                  zone_3 = optional(bool, true)
                }), {})
              }), {})
            }), {})
            spoke_virtual_network_resource_ids        = optional(list(string), [])
            secure_spoke_virtual_network_resource_ids = optional(list(string), [])
            enable_virtual_hub_connections            = optional(bool, false)
          })
        })
      ), [])
      ddos_protection_plan = optional(object({
        enabled = optional(bool, false)
        config = optional(object({
          location = optional(string, "")
        }), {})
      }), {})
      dns = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          location = optional(string, "")
          enable_private_link_by_service = optional(object({
            azure_api_management                 = optional(bool, true)
            azure_app_configuration_stores       = optional(bool, true)
            azure_arc                            = optional(bool, true)
            azure_automation_dscandhybridworker  = optional(bool, true)
            azure_automation_webhook             = optional(bool, true)
            azure_backup                         = optional(bool, true)
            azure_batch_account                  = optional(bool, true)
            azure_bot_service_bot                = optional(bool, true)
            azure_bot_service_token              = optional(bool, true)
            azure_cache_for_redis                = optional(bool, true)
            azure_cache_for_redis_enterprise     = optional(bool, true)
            azure_container_registry             = optional(bool, true)
            azure_cosmos_db_cassandra            = optional(bool, true)
            azure_cosmos_db_gremlin              = optional(bool, true)
            azure_cosmos_db_mongodb              = optional(bool, true)
            azure_cosmos_db_sql                  = optional(bool, true)
            azure_cosmos_db_table                = optional(bool, true)
            azure_data_explorer                  = optional(bool, true)
            azure_data_factory                   = optional(bool, true)
            azure_data_factory_portal            = optional(bool, true)
            azure_data_health_data_services      = optional(bool, true)
            azure_data_lake_file_system_gen2     = optional(bool, true)
            azure_database_for_mariadb_server    = optional(bool, true)
            azure_database_for_mysql_server      = optional(bool, true)
            azure_database_for_postgresql_server = optional(bool, true)
            azure_digital_twins                  = optional(bool, true)
            azure_event_grid_domain              = optional(bool, true)
            azure_event_grid_topic               = optional(bool, true)
            azure_event_hubs_namespace           = optional(bool, true)
            azure_file_sync                      = optional(bool, true)
            azure_hdinsights                     = optional(bool, true)
            azure_iot_dps                        = optional(bool, true)
            azure_iot_hub                        = optional(bool, true)
            azure_key_vault                      = optional(bool, true)
            azure_key_vault_managed_hsm          = optional(bool, true)
            azure_kubernetes_service_management  = optional(bool, true)
            azure_machine_learning_workspace     = optional(bool, true)
            azure_managed_disks                  = optional(bool, true)
            azure_media_services                 = optional(bool, true)
            azure_migrate                        = optional(bool, true)
            azure_monitor                        = optional(bool, true)
            azure_purview_account                = optional(bool, true)
            azure_purview_studio                 = optional(bool, true)
            azure_relay_namespace                = optional(bool, true)
            azure_search_service                 = optional(bool, true)
            azure_service_bus_namespace          = optional(bool, true)
            azure_site_recovery                  = optional(bool, true)
            azure_sql_database_sqlserver         = optional(bool, true)
            azure_synapse_analytics_dev          = optional(bool, true)
            azure_synapse_analytics_sql          = optional(bool, true)
            azure_synapse_studio                 = optional(bool, true)
            azure_web_apps_sites                 = optional(bool, true)
            azure_web_apps_static_sites          = optional(bool, true)
            cognitive_services_account           = optional(bool, true)
            microsoft_power_bi                   = optional(bool, true)
            signalr                              = optional(bool, true)
            signalr_webpubsub                    = optional(bool, true)
            storage_account_blob                 = optional(bool, true)
            storage_account_file                 = optional(bool, true)
            storage_account_queue                = optional(bool, true)
            storage_account_table                = optional(bool, true)
            storage_account_web                  = optional(bool, true)
          }), {})
          private_link_locations                                 = optional(list(string), [])
          public_dns_zones                                       = optional(list(string), [])
          private_dns_zones                                      = optional(list(string), [])
          enable_private_dns_zone_virtual_network_link_on_hubs   = optional(bool, true)
          enable_private_dns_zone_virtual_network_link_on_spokes = optional(bool, true)
          virtual_network_resource_ids_to_link                   = optional(list(string), [])
        }), {})
      }), {})
    }), {})
    location = optional(string, "")
    tags     = optional(any, {})
    advanced = optional(any, {})
  })
  description = "If specified, will customize the \"Connectivity\" landing zone settings and resources."
  default = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = ["10.100.0.0/16", ]
            location                     = ""
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = false
              config = {
                address_prefix           = "10.100.1.0/24"
                gateway_sku_expressroute = "ErGw2AZ"
                gateway_sku_vpn          = "VpnGw3"
                advanced_vpn_settings = {
                  enable_bgp                       = null
                  active_active                    = null
                  private_ip_address_allocation    = ""
                  default_local_network_gateway_id = ""
                  vpn_client_configuration         = []
                  bgp_settings                     = []
                  custom_route                     = []
                }
              }
            }
            azure_firewall = {
              enabled = false
              config = {
                address_prefix                = "10.100.0.0/24"
                enable_dns_proxy              = true
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = []
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
            enable_hub_network_mesh_peering         = false
          }
        },
      ]
      vwan_hub_networks = [
        {
          enabled = false
          config = {
            address_prefix = "10.200.0.0/22"
            location       = ""
            sku            = ""
            routes         = []
            expressroute_gateway = {
              enabled = false
              config = {
                scale_unit = 1
              }
            }
            vpn_gateway = {
              enabled = false
              config = {
                bgp_settings       = []
                routing_preference = ""
                scale_unit         = 1
              }
            }
            azure_firewall = {
              enabled = false
              config = {
                enable_dns_proxy              = false
                dns_servers                   = []
                sku_tier                      = "Standard"
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = []
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids        = []
            secure_spoke_virtual_network_resource_ids = []
            enable_virtual_hub_connections            = false
          }
        },
      ]
      ddos_protection_plan = {
        enabled = false
        config = {
          location = ""
        }
      }
      dns = {
        enabled = true
        config = {
          location = ""
          enable_private_link_by_service = {
            azure_api_management                 = true
            azure_app_configuration_stores       = true
            azure_arc                            = true
            azure_automation_dscandhybridworker  = true
            azure_automation_webhook             = true
            azure_backup                         = true
            azure_batch_account                  = true
            azure_bot_service_bot                = true
            azure_bot_service_token              = true
            azure_cache_for_redis                = true
            azure_cache_for_redis_enterprise     = true
            azure_container_registry             = true
            azure_cosmos_db_cassandra            = true
            azure_cosmos_db_gremlin              = true
            azure_cosmos_db_mongodb              = true
            azure_cosmos_db_sql                  = true
            azure_cosmos_db_table                = true
            azure_data_explorer                  = true
            azure_data_factory                   = true
            azure_data_factory_portal            = true
            azure_data_health_data_services      = true
            azure_data_lake_file_system_gen2     = true
            azure_database_for_mariadb_server    = true
            azure_database_for_mysql_server      = true
            azure_database_for_postgresql_server = true
            azure_digital_twins                  = true
            azure_event_grid_domain              = true
            azure_event_grid_topic               = true
            azure_event_hubs_namespace           = true
            azure_file_sync                      = true
            azure_hdinsights                     = true
            azure_iot_dps                        = true
            azure_iot_hub                        = true
            azure_key_vault                      = true
            azure_key_vault_managed_hsm          = true
            azure_kubernetes_service_management  = true
            azure_machine_learning_workspace     = true
            azure_managed_disks                  = true
            azure_media_services                 = true
            azure_migrate                        = true
            azure_monitor                        = true
            azure_purview_account                = true
            azure_purview_studio                 = true
            azure_relay_namespace                = true
            azure_search_service                 = true
            azure_service_bus_namespace          = true
            azure_site_recovery                  = true
            azure_sql_database_sqlserver         = true
            azure_synapse_analytics_dev          = true
            azure_synapse_analytics_sql          = true
            azure_synapse_studio                 = true
            azure_web_apps_sites                 = true
            azure_web_apps_static_sites          = true
            cognitive_services_account           = true
            microsoft_power_bi                   = true
            signalr                              = true
            signalr_webpubsub                    = true
            storage_account_blob                 = true
            storage_account_file                 = true
            storage_account_queue                = true
            storage_account_table                = true
            storage_account_web                  = true
          }
          private_link_locations                                 = []
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
          virtual_network_resource_ids_to_link                   = []
        }
      }
    }
  }
}

variable "enable_ddos_protection" {
  type        = bool
  description = "Controls whether to create a DDoS Network Protection plan and link to hub virtual networks."
  default     = false
}

###################################################################################################################################################################################################

# Core Variables
# used for the core deployment

variable "subscription_id_identity" {
  type        = string
  description = "Subscription ID to use for \"identity\" resources."
  default     = ""
}

variable "configure_identity_resources" {
  type = object({
    settings = optional(object({
      identity = optional(object({
        enabled = optional(bool, true)
        config = optional(object({
          enable_deny_public_ip             = optional(bool, true)
          enable_deny_rdp_from_internet     = optional(bool, true)
          enable_deny_subnet_without_nsg    = optional(bool, true)
          enable_deploy_azure_backup_on_vms = optional(bool, true)
        }), {})
      }), {})
    }), {})
  })
  description = "If specified, will customize the \"Identity\" landing zone settings."
  default = {
    settings = {
      identity = {
        enabled = true
        config = {
          enable_deny_public_ip             = true
          enable_deny_rdp_from_internet     = true
          enable_deny_subnet_without_nsg    = true
          enable_deploy_azure_backup_on_vms = true
        }
      }
    }
  }
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

###################################################################################################################################################################################################
