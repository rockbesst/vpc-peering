variable "region" {
}

variable "tags" {
  default = {
      Owner = "Rockbesst"
  }
}

variable "ssh_key" {
  default = "AWS-Frankfurt-test1"
}

variable "allow_public_ip" {
  type = bool
  default = false
}

variable "instance_type" {
  default = "t2.micro"
}

variable "cidr_block"{}
