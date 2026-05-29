variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  description = "AVD subnet ID where the session host NIC will sit"
  type        = string
}

variable "vm_name" {
  description = "Session host VM name (computer name, <=15 chars)"
  type        = string
  default     = "sh01"

  validation {
    condition     = length(var.vm_name) <= 15
    error_message = "Windows computer name must be 15 characters or less."
  }
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "labadmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "host_pool_name" {
  description = "Target AVD host pool name"
  type        = string
}

variable "registration_token" {
  description = "Host pool registration token from avd-core module"
  type        = string
  sensitive   = true
}

variable "avd_dsc_config_url" {
  description = "URL of the Microsoft AVD DSC configuration package"
  type        = string
  default     = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02990.697.zip"
}

variable "auto_shutdown_time" {
  type    = string
  default = "2300"
}

variable "auto_shutdown_timezone" {
  type    = string
  default = "India Standard Time"
}

variable "tags" {
  type    = map(string)
  default = {}
}
