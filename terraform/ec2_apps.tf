# Application Instances
resource "aws_instance" "apps" {
  count                  = var.app_instance_count
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.app_instance_type
  subnet_id              = element(data.aws_subnets.selected.ids, count.index)
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name       = "app-instance-${count.index}"
    Role       = "client"
    Monitoring = "enabled"
  }
}

