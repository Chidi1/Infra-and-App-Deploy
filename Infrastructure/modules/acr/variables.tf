variable "acr_name" {
  type        = string
  description = "The name of the Azure Container Registry (ACR) to be created."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the resources will be deployed."
}
