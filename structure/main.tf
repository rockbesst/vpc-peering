resource "aws_instance" "WebServer1" {
	ami = data.aws_ami.amazon_linux.id
	instance_type = var.instance_type
	vpc_security_group_ids = [aws_security_group.asg.id]
	key_name = var.ssh_key
	associate_public_ip_address = var.allow_public_ip
	tags = merge(var.tags, {Name = "WebServer1"})
}

# AMI Search
data "aws_ami" "amazon_linux" {
	owners = ["amazon"]
	most_recent = true
	filter {
		name = "name"
		values = ["amzn2-ami-hvm-*-x86_64-gp2"]
	}
}

resource "aws_vpc" "vpc" {
  	cidr_block = var.cidr_block
}

resource "aws_security_group" "asg" {
  name        = "default ASG"
  description = "SG for Frankfurt region"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }
  tags = {
    Name = "SG for Frankfurt region"
  }
}