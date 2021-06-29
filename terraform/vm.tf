# En el fichero vm.tf incluiremos la definición de la vm red que vayamos a crear.
# Creamos una máquina virtual
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

# configuracion de usuario con cloud_init
#data "template_file" "user_data" {
#   template = file("${path.module}/cloud-init_user_data.cfg")
#}

# Data template Bash bootstrapping file
# https://medium.com/microsoftazure/custom-azure-vm-scale-sets-with-terraform-and-cloud-init-6a592dc41523
data "local_file" "user_data" {
    filename = "${path.module}/cloud-init_user_data.cfg"
}

resource "azurerm_linux_virtual_machine" "myVM" {
    count               = length(var.vms)
    name                = "vm-${var.vms[count.index]}"
    computer_name       = "${var.vms[count.index]}"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location

    size                = var.vm_size
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
    #custom_data      = data.template_file.user_data.rendered    
}

resource "azurerm_managed_disk" "myManagedDisk" {
    name                 = "managed-disk-data"
    location             = azurerm_resource_group.rg.location
    resource_group_name  = azurerm_resource_group.rg.name
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "myDataDisk" {
    count              = length(var.vms_disks_index_number)
    managed_disk_id    = azurerm_managed_disk.myManagedDisk.id
    virtual_machine_id = azurerm_linux_virtual_machine.myVM["${var.vms_disks_index_number[count.index]}"].id
    lun                = "${count.index  + 10}"
    caching            = "ReadWrite"
}