terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

variable "pm_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive = true
}

variable "pm_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive = true
}

variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

provider "proxmox" {
  pm_api_token_id      = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_api_url          = var.pm_api_url
  pm_tls_insecure     = true
}