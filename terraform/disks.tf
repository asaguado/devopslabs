resource "azurerm_managed_disk" "myManagedDisk" {
    name                 = "managed-disk-data"
    location             = azurerm_resource_group.main.location
    resource_group_name  = azurerm_resource_group.main.name
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "myDataDisk" {
    count             = "${var.vms_disks == 1 ? 1 : 0}"
    managed_disk_id    = azurerm_managed_disk.myManagedDisk.id
    virtual_machine_id = azurerm_virtual_machine.myVM[count.index].id
    lun                = "10"
    caching            = "ReadWrite"
}