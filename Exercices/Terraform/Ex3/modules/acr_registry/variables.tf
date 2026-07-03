variable "rg_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "acr_name" {
  description = "Nom du Azure Container Registry"
  type        = string
}

variable "acr_sku" {
  description = "SKU du Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "acr_admin_enabled" {
  description = "Activer l'accès administrateur"
  type        = bool
  default     = false
}
