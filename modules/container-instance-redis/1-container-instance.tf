# ---------------------------------------------------------------------------
# Resource Group - which contains the deployed resources.
# ---------------------------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = "${var.name_prefix}-resources"
  location = var.location
  tags     = var.tags
}

# ---------------------------------------------------------------------------
# Container Instance (Container Group) - runs the Redis-backed application.
#
# The image is pulled directly from Docker Hub (a public image), so there's no
# Container Registry to provision or import into. The container serves plain
# HTTP on app_port; Gondola publishes the group at its *.gondola.locally name
# and routes to the container on that port (see locals.tf).
# ---------------------------------------------------------------------------
resource "azurerm_container_group" "main" {
  name                = local.container_group_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = local.container_group_name
  tags                = var.tags

  container {
    name   = "app"
    image  = var.container_image
    cpu    = 1.0
    memory = 1.5

    ports {
      port     = local.app_port
      protocol = "TCP"
    }

    environment_variables = {
      # Where to reach Redis over TLS. On Azure the SSL port is always 6380; on
      # Locally the cache is served on a dynamically-allocated SSL port, so the
      # app reads the port from REDIS_PORT rather than assuming 6380.
      REDIS_HOST = azurerm_redis_cache.main.hostname
      REDIS_PORT = tostring(azurerm_redis_cache.main.ssl_port)
    }

    secure_environment_variables = {
      # The access key, kept out of the plain (readable) environment. There's no
      # managed-identity data path on a Basic cache, so the app authenticates
      # with this key.
      REDIS_KEY = azurerm_redis_cache.main.primary_access_key
    }
  }
}
