# IP address space for the main network
variable "address_spaces" {
  type = string
  description = "IP address space for the main network"
  default = "10.0.0.0/16"   # 10.0.0.0/16 >> 10.0.0.0 - 10.0.255.255 (65536 direcciones)
}

# IP address space for the subnet network
variable "subnet_address_prefixes" {
  type = string
  description = "IP address space for the subnet network"
  default = "10.0.1.0/24"   # 10.0.1.0/24 >> 10.0.1.0 - 10.0.1.255 (251 + 5 direcciones reservadas de Azure)
}

# https://learn.hashicorp.com/tutorials/terraform/variables?in=terraform/configuration-language
# https://docs.microsoft.com/es-es/azure/cloud-services/cloud-services-sizes-specs
# default = "Standard_A2_v2" # 2 CPU, 4.0 GB RAM, 20 GB SSD, NIC 2 / moderado (limitado a 2 máquinas)
# default = "Standard_D2_v3" # 2 CPU, 8.0 GB RAM, 50 GB SSD, NIC 2 / moderado
# default = "Standard_D1_v2" # 1 CPU, 3.5 GB RAM, 50 GB SS, NIC 1 / moderado
variable "vm_size" {
  description = "Size of the Virtual Mahines"  
  type = string
  default = "Standard_D1_v2" # 1 CPU, 3.5 GB RAM, 50 GB SS, NIC 1 / moderado
}

# List of virtual machines to install
variable "vms" {
  description = "List of virtual machines to install"
  type = list(string)
  default = [ "master", "worker01", "worker02", "nfs" ]
}

# "master"=0, "worker01"=1, "worker02"=2, "nfs"=3
variable "vms_disks_index_number" {
  description = "Managed disk in Virtual Machines"
  type = list(number)
  default = [3]
}

# Managed disk size in GB
variable "disk_size" {
  description = "Admin username (no root)"  
  type = number
  default = 10
}

# Name of the no-root user
variable "admin_username" {
  description = "Admin username (no root)"  
  type = string
  default = "kubeadmin"
}