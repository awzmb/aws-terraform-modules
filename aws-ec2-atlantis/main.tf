# get the latest amazon linux 2023 ami
data "aws_ami" "amzn_linux_2023_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "aws_iam_instance_profile" "ec2_iam_profile" {
  name = var.iam_profile_name
}

resource "aws_key_pair" "ec2_ssh_public_key" {
  key_name   = "${var.name}-ssh-key"
  public_key = var.ssh_public_key
}

data "http" "bitbucket_ips" {
  url = "https://ip-ranges.atlassian.com/"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  bitbucket_ipv4_cidrs = [for c in jsondecode(data.http.bitbucket_ips.response_body).items : c.cidr if length(regexall(":", c.cidr)) == 0]
  bitbucket_ipv6_cidrs = [for c in jsondecode(data.http.bitbucket_ips.response_body).items : c.cidr if length(regexall(":", c.cidr)) > 0]
}

# fetch data from vpc per id
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

module "security_groups" {
  source = "git::git@bitbucket.org:metamorphant/aws-atlantis-security-groups.git//.?ref=1.0.0"

  atlantis_port = var.atlantis_port
  vpc_id        = data.aws_vpc.vpc.id
  tags          = var.tags
}


resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.amzn_linux_2023_ami.id
  instance_type = var.instance_type

  key_name                    = aws_key_pair.ec2_ssh_public_key.key_name
  iam_instance_profile        = var.iam_profile_name
  associate_public_ip_address = true

  monitoring = false

  subnet_id = var.subnet_id
  vpc_security_group_ids    = module.security_groups.alb_security_group_ids

  root_block_device {
    delete_on_termination = true
    volume_size           = var.root_volume_size

    tags = var.tags
  }

  # install ssm-agent and docker via user_data
  # NOTE: even though we are using the latest amazon linux 2023 ami, apparently we
  # need to do this, since the ssm agent is not enabled by default
  user_data = <<EOT
#!/bin/bash
cd /tmp
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo dnf update
sudo dnf -y install docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
sudo newgrp docker
EOT

  tags = var.tags
}
