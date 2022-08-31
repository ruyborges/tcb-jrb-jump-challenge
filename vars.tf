#Azure Location
variable "AZURE_LOCATION" {
    type = string
    default = "brazilsouth"
}

#RG Name
variable "RG_NAME" {
    type = string
    default = "tcb-jrb-jump-challenge"
}

#VNET CIDR
variable "VNET_CIDR" {
    type = string
    default = "10.0.0.0/16"
}

#SUBNET_INTERNAL_CIDR
variable "internal_subnet_CIDR" {
    type = string
    default = "10.0.1.0/24"
}

#Subscription ID
variable "SUB_ID" {
    type = string
    default = "" // type the value here if you followed the article: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
}

#Principal Client ID
variable "CLI_ID" {
    type = string
    default = "" // type the value here if you followed the article: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
}

#Principal Client SECRET
variable "CLI_SECRET" {
    type = string
    default = "" // type the value here if you followed the article: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
} 

#Tenant ID  
variable "TEN_ID" {
    type = string
    default = "" // type the value here if you followed the article: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
} 
