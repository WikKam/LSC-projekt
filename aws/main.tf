terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

variable "key_pair_name" {
  type = string
  description = "The name of the key pair used to ssh into ec2s"
  default = "vockey" # this is the one generated automatically by AWS academy, used to be 'karol' :D
}

variable "workers_count" {
  type = number
  description = "The number of ec2 worker machines to create"
  default = 8
}

resource "aws_security_group" "allow_ssh_http_https" {
  name        = "vm-security-group"
  description = "Allow SSH, HTTP and HTTPS traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "k3s"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "flannel"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "k3s-metrics"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "nomad-http"
    from_port   = 4646
    to_port     = 4646
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "nomad-rpc"
    from_port   = 4647
    to_port     = 4647
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "nomad-serf"
    from_port   = 4648
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "master" {
  ami                         = "ami-0b93ce03dcbcb10f6" # Ubuntu 20.04
  instance_type               = "t3.small"
  key_name                    = var.key_pair_name
  security_groups             = [aws_security_group.allow_ssh_http_https.name]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "cluster-master"
  }
}

resource "aws_instance" "worker" {
  count = var.workers_count

  ami                         = "ami-0b93ce03dcbcb10f6" # Ubuntu 20.04
  instance_type               = "t3.small"
  key_name                    = var.key_pair_name
  security_groups             = [aws_security_group.allow_ssh_http_https.name]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "cluster-worker-${count.index}"
  }
}

output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "worker_public_ips" {
  value = aws_instance.worker.*.public_ip
}
