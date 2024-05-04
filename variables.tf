variable "region" {
  type = string
  default = "us-east-1"
}

variable "cidr" {
    default = "10.0.0.0/16"
}

variable "env" {
    default = "dev"
}

variable "private_subnets" {
  default = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
}

variable "public_subnets" {
  default = ["10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19"]
}

variable "tags" {
  default = {terraform = "true"}
}