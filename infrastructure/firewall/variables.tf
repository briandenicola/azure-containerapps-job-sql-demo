variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "app_name" {
  description = "Name of the application to deploy"
}

variable "rg_name" {
  description = "Resource Group Name to deploy Azure firewall to"
}