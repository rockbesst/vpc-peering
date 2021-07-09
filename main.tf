provider "aws" {
	region = "eu-central-1"
}
provider "aws" {
	region = "eu-west-1"
    alias = "ire"
}
resource "aws_vpc_peering_connection" "peer" {
    depends_on = [
        aws_vpc.vpc_ire,
        aws_vpc.vpc_fra
    ]
  peer_vpc_id   = aws_vpc.vpc_ire.id  #до якої запит
  peer_region = aws.Ireland
  vpc_id        = aws_vpc.vpc_fra.id  #з якої запит
 # peer_region   = "us-east-1"
 auto_accept = true
}

resource "aws_vpc" "vpc_fra" {
  cidr_block = "192.168.0.0/16"
}
resource "aws_subnet" "sub_fra" {
    vpc_id     = aws_vpc.vpc_fra.id
    cidr_block = "192.168.1.0/24"
}

resource "aws_vpc" "vpc_ire" {
  provider   = aws.ire
  cidr_block = "10.2.0.0/16"
}
resource "aws_subnet" "sub_ire" {
    provider = aws.ire
    vpc_id     = aws_vpc.vpc_ire.id
    cidr_block = "10.2.1.0/24"
}

resource "aws_security_group" "asg_fra" {
    depends_on = [aws_vpc.vpc_fra]
  name        = "asg_fra"
  description = "SG for Frankfurt region"
  vpc_id      = aws_vpc.vpc_fra.id
  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc_fra.cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc_fra.cidr_block]
  }
  tags = {
    Name = "SG for Frankfurt region"
  }
}

resource "aws_security_group" "asg_ire" {
    provider = aws.ire
    depends_on = [aws_vpc.vpc_ire]
  name        = "asg_ire"
  description = "SG for Ireland region"
  vpc_id      = aws_vpc.vpc_ire.id
  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc_ire.cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc_ire.cidr_block]
  }
  tags = {
    Name = "SG for Ireland region"
  }
} 