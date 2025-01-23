# Reference to an existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#Azure K8s
resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.location
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  tags                = {
    Environment = "Dev"
  }

  default_node_pool {
    name                 = "agentpool"
    vm_size              = "Standard_D2_v2"
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    type                 = "VirtualMachineScaleSets"
    orchestrator_version = "1.30.7"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = var.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}