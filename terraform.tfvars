resource_group_name = "AVD-Lab"
location            = "Southeast Asia"

tags = {
  Environment = "Lab"
  Project     = "AVD_Lab"
  Owner       = "Shabeer"
}

vnet_name          = "Vnet01"
vnet_address_space = ["10.0.0.0/16"]

subnets = {
  avd = { address_prefixes = ["10.0.2.0/24"] }
}

nsg_name       = "nsg-avd-lab"
admin_source_ip = "49.206.129.31"   # Replace with your actual public IP: curl ifconfig.me

admin_username         = "labadmin"
auto_shutdown_time     = "2300"
auto_shutdown_timezone = "India Standard Time"

sh_vm_name = "sh01"
sh_vm_size = "Standard_D2as_v5"

fslogix_storage_account_name = "stfslogixshabeer042"
