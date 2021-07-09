resource "aws_instance" "WebServer1" {
    depends_on = [aws_security_group.asg_fra]
	ami = data.aws_ami.amazon_linux.id
	instance_type = var.instance_type
	vpc_security_group_ids = [aws_security_group.asg_fra.id]
	key_name = var.ssh_key
	associate_public_ip_address = var.allow_public_ip
	tags = merge(var.tags, {Name = "WebServer1"})
}

resource "aws_instance" "WebServer2" {
    depends_on = [aws_security_group.asg_ire]
	provider = aws.ire
	ami = data.aws_ami.amazon_linux.id
	instance_type = var.instance_type
	vpc_security_group_ids = [aws_security_group.asg_ire.id]
	associate_public_ip_address = var.allow_public_ip
	tags = merge(var.tags, {Name = "WebServer2"})
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