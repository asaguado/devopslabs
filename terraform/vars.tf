# En el fichero vars.tf incluiremos las variables que vayamos a utilizar.

variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "West Europe"
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