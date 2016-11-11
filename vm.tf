# Create virtal machine and define image to install on VM 

variable "admin_username" {}

variable "admin_password" {}

resource "azurerm_virtual_machine" "vmtest" {
  count                 = "2"
  name                  = "as-web*"
  location              = "centralus"
  resource_group_name   = "${azurerm_resource_group.ResourceGrps.name}"
  network_interface_ids = ["${azurerm_network_interface.nics.id}"]
  availability_set_id   = "${azurerm_availability_set.AvailabilitySets.id}"
  vm_size               = "Standard_A2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  # Assign vhd blob storage and create a profile

  storage_os_disk {
    name          = "osdisk0"
    vhd_uri       = "${azurerm_storage_account.stacc2.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/osdisk0.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk0"
    vhd_uri       = "${azurerm_storage_account.stacc2.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/datadisk0.vhd"
    disk_size_gb  = "250"
    create_option = "empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "asotvm01"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = "false"
    provision_vm_agent        = "false"
  }
}
