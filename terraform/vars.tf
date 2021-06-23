# En el fichero vars.tf incluiremos las variables que vayamos a utilizar.
variable "address_spaces" {
  type = string
  description = "Espacio de direcciones IP para la red principal"
  default = "10.0.0.0/16"   # 10.0.0.0/16 >> 10.0.0.0 - 10.0.255.255 (65536 direcciones)
}

variable "subnet_address_prefixes" {
  type = string
  description = "Espacio de direcciones IP para la red subred"
  default = "10.0.1.0/24"   # 10.0.1.0/24 >> 10.0.1.0 - 10.0.1.255 (251 + 5 direcciones reservadas de Azure)
}

# https://learn.hashicorp.com/tutorials/terraform/variables?in=terraform/configuration-language
# https://docs.microsoft.com/es-es/azure/cloud-services/cloud-services-sizes-specs
# default = "Standard_A2_v2" # 2 CPU,  4.0 GB RAM, 20 GB SSD, NIC 2 / moderado
# default = "Standard_D2_v3" # 2 CPU,  8.0 GB RAM, 50 GB SSD, NIC 2 / moderado
variable "vm_size" {
  description = "Tamaño de la máquina virtual"  
  type = string
  default = "Standard_A2_v2" # 2 CPU,  4.0 GB RAM, 20 GB SSD
}

variable "vms" {
  description = "Máquinas virtuales"
  type = list(string)
  default = [ "master", "worker01", "worker02", "nfs" ]
}