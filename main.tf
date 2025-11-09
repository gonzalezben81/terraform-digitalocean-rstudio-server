module "rstudio_server" {
  source = "./modules/rstudio-server"
  do_token          = var.do_token
  plex_ssh_key_name = var.rstudio_ssh_key_name
  droplet_name      = var.droplet_name
  droplet_region    = var.droplet_region
  droplet_size      = var.droplet_size
  droplet_image     = var.droplet_image
  github_user_name = var.github_username
  github_username = var.github_username
}