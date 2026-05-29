resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Premium"
  account_replication_type        = "LRS"
  account_kind                    = "FileStorage"
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
}

resource "azurerm_storage_share" "profiles" {
  name               = var.share_name
  storage_account_id = azurerm_storage_account.this.id
  quota              = var.share_quota_gb
  enabled_protocol   = "SMB"
}

locals {
  fslogix_script = templatefile("${path.module}/scripts/install-fslogix.ps1.tftpl", {
    share_path      = "\\\\${azurerm_storage_account.this.name}.file.core.windows.net\\${azurerm_storage_share.profiles.name}"
    size_in_mbs     = var.fslogix_initial_size_mb
    storage_account = azurerm_storage_account.this.name
    storage_key_b64 = base64encode(azurerm_storage_account.this.primary_access_key)
  })
}

resource "azurerm_virtual_machine_extension" "install_fslogix" {
  name                       = "install-fslogix"
  virtual_machine_id         = var.session_host_vm_id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  protected_settings = jsonencode({
    commandToExecute = "powershell.exe -ExecutionPolicy Unrestricted -EncodedCommand ${textencodebase64(local.fslogix_script, "UTF-16LE")}"
  })

  timeouts {
      create = "60m"
      update = "60m"
      delete = "30m"
   }
}