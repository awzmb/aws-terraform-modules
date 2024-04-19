terraform {
  required_providers {
    aws = "> 5.0"
    cloudinit = "> 2.0"
  }
}

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

data "cloudinit_config" "ec2_cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "base_init.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/base_init.sh")
  }

  part {
    content_type = "text/plain"
    content      = var.cloudinit_config
  }
}


resource "aws_instance" "ec2_instance" {
  #checkov:skip=CKV_AWS_135:We don't currently care about EBS-optimization
  ami           = data.aws_ami.amzn_linux_2023_ami.id
  instance_type = var.instance_type

  key_name                    = aws_key_pair.ec2_ssh_public_key.key_name
  iam_instance_profile        = var.iam_profile_name
  associate_public_ip_address = var.associate_public_ipv4_address

  monitoring = false

  metadata_options {
    http_protocol_ipv6 = var.metadata_endpoint_ipv6
  }

  subnet_id = var.subnet_id

  root_block_device {
    delete_on_termination = true
    volume_size           = var.root_volume_size

    tags = var.tags
  }

  # install ssm-agent and docker via user_data
  # NOTE: even though we are using the latest amazon linux 2023 ami, apparently we
  # need to do this, since the ssm agent is not enabled by default
  user_data = data.cloudinit_config.ec2_cloudinit.rendered
  tags      = var.tags
}


data "aws_instance" "current" {
  instance_id = aws_instance.ec2_instance.id
}

# resource "aws_route53_record" "record_a" {
#   count      = var.hosted_zone_id != "" ? (data.aws_instance.current.public_ip != "" ? 1 : 0) : 0
#   zone_id    = var.hosted_zone_id
#   name       = var.name
#   type       = "A"
#   ttl        = 300
#   records    = [aws_instance.ec2_instance.public_ip]
# }

resource "aws_route53_record" "record_aaaa" {
  count      = var.hosted_zone_id != "" ? (data.aws_instance.current.ipv6_addresses != "" ? 1 : 0) : 0
  zone_id    = var.hosted_zone_id
  name       = var.name
  type       = "AAAA"
  ttl        = 300
  records    = data.aws_instance.current.ipv6_addresses
}
