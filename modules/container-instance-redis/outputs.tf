output "application_url" {
  description = "Where to reach the application in a browser."
  value       = local.app_public_url
}

output "resource_group" {
  description = "The resource group containing the deployed resources."
  value       = azurerm_resource_group.main.name
}

output "redis_hostname" {
  description = "The Redis cache hostname the application connects to."
  value       = azurerm_redis_cache.main.hostname
}
