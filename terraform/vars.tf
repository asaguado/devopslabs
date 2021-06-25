# Espacio de direcciones IP para la red principal
variable "address_spaces" {
  type = string
  description = "Espacio de direcciones IP para la red principal"
  default = "10.0.0.0/16"   # 10.0.0.0/16 >> 10.0.0.0 - 10.0.255.255 (65536 direcciones)
}

# Espacio de direcciones IP para la red subred
variable "subnet_address_prefixes" {
  type = string
  description = "Espacio de direcciones IP para la red subred"
  default = "10.0.1.0/24"   # 10.0.1.0/24 >> 10.0.1.0 - 10.0.1.255 (251 + 5 direcciones reservadas de Azure)
}

# https://learn.hashicorp.com/tutorials/terraform/variables?in=terraform/configuration-language
# https://docs.microsoft.com/es-es/azure/cloud-services/cloud-services-sizes-specs
# default = "Standard_A2_v2" # 2 CPU, 4.0 GB RAM, 20 GB SSD, NIC 2 / moderado (limitado a 2 máquinas)
# default = "Standard_D2_v3" # 2 CPU, 8.0 GB RAM, 50 GB SSD, NIC 2 / moderado
# default = "Standard_D1_v2" # 1 CPU, 3.5 GB RAM, 50 GB SS, NIC 1 / moderado
variable "vm_size" {
  description = "Tamaño de la máquina virtual"  
  type = string
  default = "Standard_D1_v2" # 1 CPU, 3.5 GB RAM, 50 GB SS, NIC 1 / moderado
}

variable "vms" {
  description = "Máquinas virtuales"
  type = list(string)
  default = [ "master", "worker01", "worker02", "nfs" ]
}

# adminuser
variable "admin_username" {
  description = "Admin username (no root)"  
  type = string
  default = "kubeadmin"
}