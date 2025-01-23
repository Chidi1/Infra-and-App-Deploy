variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed, e.g., 'uksouth'."
}

variable "cluster_name" {
  type        = string
  description = "The name of the Azure Kubernetes Service (AKS) cluster to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the resources will be deployed."
}

variable "dns_prefix" {
  type        = string
  description = "The DNS prefix for the AKS cluster, used for public FQDNs."
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry to integrate with the AKS cluster"
  type        = string
}
