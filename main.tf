#Create Resource Group
resource "azurerm_resource_group" "tcb-jrb-jump-challenge" {
  name     = var.RG_NAME
  location = var.AZURE_LOCATION
}

#Create VNET
resource "azurerm_virtual_network" "MAIN" {
  name                = "VNET-MAIN"
  address_space       = [var.VNET_CIDR]
  resource_group_name = var.RG_NAME
  location            = var.AZURE_LOCATION
}

#Create Internal Subnet
resource "azurerm_subnet" "internal-subnet" {
  name                  = "internal-subnet"
  resource_group_name   = var.RG_NAME
  virtual_network_name  = azurerm_virtual_network.MAIN.name
  address_prefixes      = [var.internal_subnet_CIDR]
}

resource "azurerm_subnet" "Azure_Bastion_Subnet" {
  name                  = "AzureBastionSubnet"
  resource_group_name   = var.RG_NAME
  virtual_network_name  = azurerm_virtual_network.MAIN.name
  address_prefixes      = ["10.0.2.0/24"]
  depends_on = [
    azurerm_virtual_network.MAIN
  ]
}

#Create Public IP for Bastion
resource "azurerm_public_ip" "bastion_ip" {
  name                = "bastion-ip"
  resource_group_name = var.RG_NAME
  location            = var.AZURE_LOCATION
  allocation_method   = "Static"
  sku = "Standard"
}

#Bastion
resource "azurerm_bastion_host" "bastion_vm" {
  name                = "bastion-vm"
  resource_group_name = var.RG_NAME
  location            = var.AZURE_LOCATION

  ip_configuration {
    name                 = "bastion-configuration"
    subnet_id            = azurerm_subnet.Azure_Bastion_Subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}

#Create VNIC for Bastion VM
resource "azurerm_network_interface" "VNIC_Bastion" {
  name                = "VNIC_Bastion"
  resource_group_name = var.RG_NAME
  location            = var.AZURE_LOCATION

  ip_configuration {
    name                          = "VNIC-ipconfig"
    subnet_id                     = azurerm_subnet.internal-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create Client Machine
resource "azurerm_virtual_machine" "bastion-linux-vm" {
  name                  = "bastion-linux-vm"
  resource_group_name   = var.RG_NAME
  location              = var.AZURE_LOCATION
  network_interface_ids = [azurerm_network_interface.VNIC_Bastion.id]
  vm_size               = "Standard_B1s"
  
  delete_os_disk_on_termination     = true
  delete_data_disks_on_termination  = true  

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name   = "bastion-linux-vm"
    admin_username  = "azureuser"
    admin_password  = "PasswordHash1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {       
        key_data  =  file("~/.ssh/id_rsa.pub")    
        path      = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}
