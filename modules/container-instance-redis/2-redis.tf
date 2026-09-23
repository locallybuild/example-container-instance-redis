# ---------------------------------------------------------------------------
# Azure Cache for Redis - the backing store for the application.
#
# A Basic C0 cache with the non-TLS port disabled, so it is reachable only over
# TLS on 6380 - the port and scheme the application connects with. The app
# authenticates with the cache's access key (there is no managed-identity data
# path on a Basic cache), which is passed to the container as a secure
# environment variable in 1-container-instance.tf.
# ---------------------------------------------------------------------------
resource "azurerm_redis_cache" "main" {
  name                 = "${var.name_prefix}-redis"
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  capacity             = 0
  family               = "C"
  sku_name             = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"
  tags                 = var.tags
}
