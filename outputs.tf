output "avd_workspace_name" {
  value = module.avd_core.workspace_name
}

output "avd_host_pool_name" {
  value = module.avd_core.host_pool_name
}

output "avd_app_group_name" {
  value = module.avd_core.app_group_name
}

output "avd_registration_token" {
  description = "Used by session hosts to register with the pool. Sensitive."
  value       = module.avd_core.registration_token
  sensitive   = true
}

output "session_host_name" {
  value = module.session_host.vm_name
}

output "session_host_private_ip" {
  value = module.session_host.private_ip_address
}

output "session_host_admin_username" {
  value = var.admin_username
}

output "session_host_admin_password" {
  description = "Retrieve with: terraform output -raw session_host_admin_password"
  value       = random_password.admin.result
  sensitive   = true
}

output "fslogix_storage_account" { value = module.fslogix_storage.storage_account_name }
output "fslogix_share_unc"       { value = module.fslogix_storage.share_unc }
output "fslogix_share_quota_gb"  { value = module.fslogix_storage.share_quota_gb }

# =============================================================================
# FSLogix Automation
# =============================================================================
output "automation_account_name" {
  value = module.fslogix_automation.automation_account_name
}

output "hybrid_worker_group_name" {
  value = module.fslogix_automation.hybrid_worker_group_name
}

output "runbook_name" {
  value = module.fslogix_automation.runbook_name
}

output "webhook_uri" {
  value     = module.fslogix_automation.webhook_uri
  sensitive = true
}

output "fslogix_logic_app_name" {
  value = module.fslogix_automation.logic_app_name
}
