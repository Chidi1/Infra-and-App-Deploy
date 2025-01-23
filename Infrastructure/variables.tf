variable "location" {
  type        = string
  description = "The Azure region for all resources."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where resources will be deployed."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all resources."
}

# ACR variables
variable "acr_name" {
  type        = string
  description = "The name of the Azure Container Registry."
}

# Log Analytics Workspace variables
variable "log_analytics_workspace_name" {
  type        = string
  description = "The name of the Log Analytics Workspace."
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "The SKU for the Log Analytics Workspace (e.g., 'PerGB2018')."
}

# AKS variables
variable "cluster_name" {
  type        = string
  description = "The name of the AKS cluster."
}

variable "dns_prefix" {
  type        = string
  description = "The DNS prefix for the AKS cluster."
}





