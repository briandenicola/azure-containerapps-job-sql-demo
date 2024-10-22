variable "region" {
  description = "Azure region to deploy to"
  default     = "southcentralus"
}

variable "tags" {
  description = "The tags to apply to all resources"
}

variable "deploy_firewall" {
  description = "Deploy an Azure Firewall"
  default     = true
}