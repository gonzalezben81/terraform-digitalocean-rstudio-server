module "rstudio-shiny-server" {
  source = "./modules/rstudio-shiny-server"
  do_token = var.do_token

  droplet_name   = var.droplet_name # Replace with your preferred droplet name
  droplet_region = var.droplet_region # Replace with your preferred region
  droplet_size   = var.droplet_size   # Choose a size suitable for your application
  droplet_image  = var.droplet_image  # Ensure the image ID is available on DigitalOcean
  
  user_name       = var.user_name
  github_email    = var.github_email
  github_username = var.github_username
  
  rstudio_ssh_key_name = var.rstudio_ssh_key_name

}
