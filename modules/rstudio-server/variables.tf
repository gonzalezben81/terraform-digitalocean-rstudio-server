variable "droplet_name" {
  description = ""
  default     = "rstudio-test"
}
variable "droplet_region" {
  description = ""
  default     = "nyc3"
}

variable "droplet_size" {
  description = ""
  default     = "s-2vcpu-4gb"
}
variable "droplet_image" {
  description = ""
  default     = "ubuntu-24-04-x64"
}
variable "ssh_key_name" {
  description = ""
  default     = "finalrstudio"
}
variable "do_token" {
  description = "" # Leave empty to prompt for Digital Ocean API Token
}
variable "user_name" {
  description = "Username for droplet"
  default     = "datascience"
}
variable "github_email" {
  description = ""
  default     = "gonzalezben393@gmail.com"
}
variable "github_username" {
  description = ""
  default     = "gonzalezben81"
}

variable "rstudio_version" {
  description = ""
  default     = "2025.09.2-418"

}
