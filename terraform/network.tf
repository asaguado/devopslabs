# En el fichero network.tf incluiremos los recursos de red que vayamos a utilizar.
# 
# Necesitaremos crear:
# 
# - Una red, 10.0.0.0/16
# - Una subred dentro de la red anterior que será donde se conectarán las máquinas virtuales, 10.0.1.0/24.
# - Una tarjeta de red que deberemos asignar a la subred anterior.
# - Una dirección IP pública para poder acceder a ella desde fuera de Azure.

# 1. Creación de red 10.0.0.0/16
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_virtual_network" "myNet" {
  name                = "kubernetes-network"
  address_space       = [var.address_spaces] # 10.0.0.0/16 >> 10.0.0.0 - 10.0.255.255 (65536 direcciones)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "dev"
  }
}

# 2. Creación de subnet de la red anterior que será donde se conectarán las máquinas virtuales, 10.0.1.0/24.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

resource "azurerm_subnet" "mySubnet" {
  name                   = "kubernetes-internal"
  resource_group_name    = azurerm_resource_group.rg.name
  virtual_network_name   = azurerm_virtual_network.myNet.name
  address_prefixes       = [var.subnet_address_prefixes] # 10.0.1.0/24 >> 10.0.0.0 - 10.0.0.255 (251 + 5 direcciones reservadas de Azure)
}

# 3. Create NIC. Una tarjeta de red que deberemos asignar a la subred anterior.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

resource "azurerm_network_interface" "myNic" {
  count               = length(var.vms)  
  name                = "nic-${var.vms[count.index]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                           = "ipconf-${var.vms[count.index]}"
    subnet_id                      = azurerm_subnet.mySubnet.id
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.${count.index + 10}"
    #public_ip_address_id           = azurerm_public_ip.myPublicIp1.id
    public_ip_address_id           =element(azurerm_public_ip.myPublicIp.*.id, count.index)
  }

  tags = {
    environment = "dev"
  }
}

# 4. IP pública. Una dirección IP pública para poder acceder a ella desde fuera de Azure.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "myPublicIp" {
  count               = length(var.vms)  
  name                = "vmip-${var.vms[count.index]}"  
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}