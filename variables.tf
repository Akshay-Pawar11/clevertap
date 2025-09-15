variable "region" {}
variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "public-subnet-1a-cidr" {}
variable "public-subnet-2b-cidr" {}
variable "private-subnet-1a-cidr" {}
variable "private-subnet-2b-cidr" {}
variable "natgateway_name" {}
variable "ig_name" {}

variable "alb_name" {}
variable "alb_type" {}
variable "tg_name" {}
variable "bastion_host_name" {}
variable "bastion_ami" {}
variable "bastion_instance" {}
variable "launch_temp_name" {}
variable "domain" {}