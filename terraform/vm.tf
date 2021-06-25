# En el fichero vm.tf incluiremos la definición de la vm red que vayamos a crear.
# Creamos una máquina virtual
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_linux_virtual_machine" "myVM" {
    count               = length(var.vms)
    name                = "vm-${var.vms[count.index]}"
    computer_name       = "${var.vms[count.index]}"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size
    admin_username      = var.admin_username
    network_interface_ids = [element(azurerm_network_interface.myNic.*.id, count.index),]
    disable_password_authentication = true

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

}