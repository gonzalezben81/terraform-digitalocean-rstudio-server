# Output the droplet IP
output "droplet_ip" {
  description = "The Droplets public IPv4 address"
  value = digitalocean_droplet.rstudio_server.ipv4_address
}

output "droplet_hourly_cost" {
  description = "Droplet hourly price"
  value = digitalocean_droplet.rstudio_server.price_hourly
}

output "droplet_monthly_cost" {
  description = "Droplet monthly price"
  value = digitalocean_droplet.rstudio_server.price_monthly
}

output "droplet_size" {
  description = "The unique slug that identifies the type of Droplet"
  value = digitalocean_droplet.rstudio_server.size
}

output "droplet_image" {
  description = "The Droplet image ID or slug"
  value = digitalocean_droplet.rstudio_server.image
}

output "droplet_memory" {
  description = "The amount of the Droplets memory in MB."
  value = digitalocean_droplet.rstudio_server.memory
}

output "droplet_urn" {
  description = "The uniform resource name of the Droplet"
  value = digitalocean_droplet.rstudio_server.urn
}

output "droplet_id" {
  description = "The ID of the Droplet"
  value = digitalocean_droplet.rstudio_server.id
}

output "droplet_disk" {
  description = "The size of the Droplets disk in GB"
  value = digitalocean_droplet.rstudio_server.disk
}

output "droplet_tags" {
  description = "A list of the tags associated to the Droplet"
  value = digitalocean_droplet.rstudio_server.tags
}