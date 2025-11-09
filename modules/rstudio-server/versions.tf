terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.68.0"
    }
  }

  required_version = ">= 1.5.0"
}
