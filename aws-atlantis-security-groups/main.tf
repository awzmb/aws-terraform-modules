terraform {
  required_providers {
    aws = "> 3.0"
  }
}

# fetch data from vpc per id (to get ipv4/6 cidr blocks
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

module "atlassian_ip_ranges_prefix_list" {
  source = "git::git@bitbucket.org:metamorphant/aws-ec2-atlassian-prefix-list.git//."
}

resource "aws_security_group" "atlassian_alb_sg" {
  name        = "atlantis-allow-atlassian-cidrs"
  description = "Allow TLS inbound traffic from european and global Atlassian cidr blocks with unrestricted egress"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "atlassian_alb_sg_ipv4_ingress_rule" {
  security_group_id = aws_security_group.atlassian_alb_sg.id

  description    = "TLS from Atlassian ipv4"
  from_port      = 443
  to_port        = 443
  ip_protocol    = "tcp"
  prefix_list_id = module.atlassian_ip_ranges_prefix_list.ipv4_prefix_list_id
}

resource "aws_vpc_security_group_ingress_rule" "atlassian_alb_sg_ipv6_ingress_rule" {
  security_group_id = aws_security_group.atlassian_alb_sg.id

  description    = "TLS from Atlassian ipv6"
  from_port      = 443
  to_port        = 443
  ip_protocol    = "tcp"
  prefix_list_id = module.atlassian_ip_ranges_prefix_list.ipv6_prefix_list_id
}

resource "aws_vpc_security_group_egress_rule" "atlassian_alb_sg_egress_rule_ipv4" {
  security_group_id = aws_security_group.atlassian_alb_sg.id

  description = "Unrestricted egress"
  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "atlassian_alb_sg_egress_rule_ipv6" {
  security_group_id = aws_security_group.atlassian_alb_sg.id

  description = "Unrestricted egress"
  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv6   = "::/0"
}

resource "aws_security_group" "atlantis_sg" {
  # TODO: only allow traffic from previous security group after testing
  name        = "atlantis-allow-4141-from-alb"
  description = "Allow inbound port 4141 and TLS and SSH traffic and unrestricted egress"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow Atlantis ingress to Atlantis port (${var.atlantis_port})"
    from_port        = var.atlantis_port
    to_port          = var.atlantis_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}
