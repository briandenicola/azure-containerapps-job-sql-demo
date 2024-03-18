variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "deploy_firewall" {
  description = "Deploy an Azure Firewall"
  default     = true
}