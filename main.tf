provider "aws" {
  region = "us-east-1"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a"]
  public_subnets = ["10.0.1.0/24"]


}


resource "aws_security_group" "my-sg" {
  vpc_id = module.vpc.vpc_id
  name   = join("_", ["sg", module.vpc.vpc_id])
  dynamic "ingress" {
    for_each = var.rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Redis-SG"
  }
}

resource "aws_instance" "redis-master" {
  ami                         = "ami-0cd59ecaf368e5ccf"
  subnet_id                   = module.vpc.public_subnets[0]
  instance_type               = "t3.micro"
  security_groups             = [aws_security_group.my-sg.id]
  associate_public_ip_address = true
  key_name                    = var.instance_keypair
  user_data                   = fileexists("masterscript.sh") ? file("masterscript.sh") : null

  tags = {
    Name = "Redis-Master"
  }
}
resource "aws_instance" "redis-slave" {
  ami                         = "ami-0cd59ecaf368e5ccf"
  subnet_id                   = module.vpc.public_subnets[0]
  instance_type               = "t3.micro"
  security_groups             = [aws_security_group.my-sg.id]
  associate_public_ip_address = true
  key_name                    = var.instance_keypair
  user_data                   = fileexists("slavescript.sh") ? file("slavescript.sh") : null

  tags = {
    Name = "Redis-Slave"
  }
}
resource "aws_instance" "redis-cli" {
  ami                         = "ami-0cd59ecaf368e5ccf"
  subnet_id                   = module.vpc.public_subnets[0]
  instance_type               = "t3.micro"
  security_groups             = [aws_security_group.my-sg.id]
  associate_public_ip_address = true
  key_name                    = var.instance_keypair
  user_data                   = fileexists("cliscript.sh") ? file("cliscript.sh") : null

  tags = {
    Name = "Redis Cli"
  }
}
