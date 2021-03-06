# En el fichero vm.tf incluiremos la definición de la vm red que vayamos a crear.
# Creamos todas las máquinas virtuales definidas en el fichero vars.tf
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_linux_virtual_machine" "myVM" {
    count               = length(var.vms)
    name                = "vm-${var.vms[count.index]}"
    computer_name       = "${var.vms[count.index]}"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location

    #ize                = var.vm_size
    size                = "${var.vm_size[count.index]}"  
    admin_username      = var.admin_username
    disable_password_authentication = true        

    network_interface_ids = [element(azurerm_network_interface.myNic.*.id, count.index),]    

    admin_ssh_key {
        username   = var.admin_username
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.myStorageAccount.primary_blob_endpoint
    }

    tags = {
        environment = "dev"
    }

    custom_data = base64encode(data.local_file.cloudinit.content)
}

# User configuration with cloud_init
data "local_file" "cloudinit" {
    filename = "${path.module}/cloudinit.conf"
}

# Creates managed disk.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk
resource "azurerm_managed_disk" "myManagedDisk" {
    name                 = "managed-disk-data"
    location             = azurerm_resource_group.rg.location
    resource_group_name  = azurerm_resource_group.rg.name
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = var.disk_size
}

# Attaching a Disk to a Virtual Machine.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment
resource "azurerm_virtual_machine_data_disk_attachment" "myDataDisk" {
    count              = length(var.vms_disks_index_number)
    managed_disk_id    = azurerm_managed_disk.myManagedDisk.id
    virtual_machine_id = azurerm_linux_virtual_machine.myVM["${var.vms_disks_index_number[count.index]}"].id
    lun                = "${count.index  + 10}"
    caching            = "ReadWrite"
}