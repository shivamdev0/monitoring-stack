# Monitoring Server EC2
resource "aws_instance" "monitoring" {
  ami                    = data.aws_ami.amazon_linux_2023.id # ✅ AL2023 only
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnets.selected.ids, 0)
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.grafana_profile.name

  tags = {
    Name       = "monitoring-server"
    Role       = "monitoring"
    Monitoring = "enabled"
  }
}

# AMI for Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64-*"] # 👈 Strict match, only 2023 AMIs
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]

  }
}

