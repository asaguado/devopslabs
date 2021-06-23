# En el fichero security.tf incluiremos los recursos de seguridad que vayamos a utilizar.
# Security group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group

resource "azurerm_network_security_group" "mySecGroup" {
    name                = "sshtraffic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "dev"
    }
}

# Vinculamos el security group al interface de red
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association
# https://stackoverflow.com/questions/60829675/issues-with-creating-multiple-vms-with-terraform-for-azure
# https://www.ntweekly.com/2021/03/20/create-multiple-linux-vms-in-azure-with-terraform/

resource "azurerm_network_interface_security_group_association" "mySecGroupAssociation1" {
    count = length(azurerm_network_interface.myNic)
    #network_interface_id        = azurerm_network_interface.myNic1.id
    #network_interface_id      = "${azurerm_network_interface.myNic[count.index]}"
    network_interface_ids       = [element(azurerm_network_interface.myNic.*.id, count.index),]
    network_security_group_id   = azurerm_network_security_group.mySecGroup.id

}