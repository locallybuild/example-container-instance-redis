output "application_url" {
  description = "Where to reach the application in a browser."
  value       = module.container-instance-redis.application_url
}

output "redis_hostname" {
  description = "The Redis cache hostname the application connects to."
  value       = module.container-instance-redis.redis_hostname
}
