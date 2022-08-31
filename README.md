Steps:
1 - You must create the azure user principal. Reference:
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
2 - Generate your ssh key pair by using the command:
ssh-keygen -m PEM -t rsa -b 4096
3 - Clone the repository somewhere on the machine you are running terraform.
4 - Make sure the variables : #Subscription ID, #Principal Client ID, #Principal Client SECRET, #Tenant ID are updated accordingly
5 - Run on a jumpserver from azure or any other provider the following from the directory you cloned the repo:
terraform init
terraform valiate
terraform plan -out main.tfplan
terraform apply main.tfplan
It takes more or less 7 minutes to complete.
