# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create the DigitalOcean Droplet
resource "digitalocean_droplet" "rstudio_server" {
  name   = var.droplet_name # Replace with your preferred droplet name
  region = var.droplet_region # Replace with your preferred region
  size   = var.droplet_size   # Choose a size suitable for your application
  image  = var.droplet_image  # Ensure the image ID is available on DigitalOcean

  ssh_keys = [data.digitalocean_ssh_key.ssh.id]
  

  # Cloud-init script
  user_data =   templatefile("${path.module}/scripts/rstudio-server-setup.sh.tpl", {
    user_name       = var.user_name
    github_email    = var.github_email
    github_username = var.github_username
  })

  tags = ["rstudio-shiny-server"]
}
