resource "azurerm_network_interface" "sh" {
  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "sh" {
  name                  = var.vm_name
  computer_name         = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.sh.id]
  tags                  = var.tags

  os_disk {
    name                 = "osdisk-${var.vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-23h2-avd"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

# -----------------------------------------------------------------------------
# AVD Agent install + host pool registration via DSC (Entra ID joined)
# -----------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "avd_dsc" {
  name                       = "AddSessionHost"
  virtual_machine_id         = azurerm_windows_virtual_machine.sh.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    modulesUrl            = var.avd_dsc_config_url
    configurationFunction = "Configuration.ps1\\AddSessionHost"
    properties = {
      hostPoolName = var.host_pool_name
      aadJoin      = true
    }
  })

  protected_settings = jsonencode({
    properties = {
      registrationInfoToken = var.registration_token
    }
  })

  timeouts {
    create = "60m"
  }
}

# -----------------------------------------------------------------------------
# Auto-shutdown
# -----------------------------------------------------------------------------
resource "azurerm_dev_test_global_vm_shutdown_schedule" "sh" {
  virtual_machine_id    = azurerm_windows_virtual_machine.sh.id
  location              = var.location
  enabled               = true
  daily_recurrence_time = var.auto_shutdown_time
  timezone              = var.auto_shutdown_timezone
  tags                  = var.tags

  notification_settings {
    enabled = false
  }
}
