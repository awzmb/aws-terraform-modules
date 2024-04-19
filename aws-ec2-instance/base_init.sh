#!/bin/bash
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo dnf update
sudo dnf -y install docker
sudo systemctl enable --now docker
sudo newgrp docker
sudo usermod -aG docker $USER
