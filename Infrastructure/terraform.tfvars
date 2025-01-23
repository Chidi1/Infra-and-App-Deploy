//acr
acr_name            = "chidiezejaugwuacr25"
location            = "UK South"
resource_group_name = "Chidi"

//aks
cluster_name        = "demo-aks-cluster"
dns_prefix          = "taskaks"

//Log analytics workspace
log_analytics_workspace_name     = "demo-log-analytics-workspace"
log_analytics_workspace_sku      = "PerGB2018"

tags = {
  Environment = "Dev"
  Project     = "Demo"
}
