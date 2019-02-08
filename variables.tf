variable env_name {}

variable "vpc_cidr" {}

variable "dmz_cidrs" {
    type = "list"
}

variable "db_cidrs" {
    type = "list"
}

variable "availability_zones" {
  default = 2
}

variable "ssh_pub_key_deployer" {}