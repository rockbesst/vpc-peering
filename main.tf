module "structure_fra"{
  source = "./structure"
  region = "eu-central-1"
  cidr_block = "192.168.0.0/16"
}

module "structure_ire"{
  source = "./structure"
  region = "eu-west-1"
  cidr_block = "10.2.0.0/16"
}

resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id   = module.structure_ire.aws_vpc.vpc.id  #до якої запит
  vpc_id        = module.structure_fra.aws_vpc.vpc.id  #з якої запит
 # peer_region   = "us-east-1"
 auto_accept = true
}