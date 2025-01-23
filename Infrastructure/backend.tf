terraform {
  backend "azurerm" {
    resource_group_name  = "Chidi"          
    storage_account_name = "demomigratetfstate"           
    container_name       = "tfstate"                   
    key                  = "demoterraform.tfstate"         
  }
}
