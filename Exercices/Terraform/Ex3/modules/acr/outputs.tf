output "acr_login_server" {
  description = "Login server du registry"
  value       = azurerm_container_registry.acr.login_server
}
