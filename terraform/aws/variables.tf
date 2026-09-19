variable "aws_access_key_id" {
  default = ""
}
variable "aws_secret_access_key" {
  default = ""
}
variable "aws_region" {
  default = "eu-west-2"
}
variable "env_prefix" {
  type    = string
  default = "dev"
}
variable "runner_registration_token" {
  default   = ""
  sensitive = true
}
