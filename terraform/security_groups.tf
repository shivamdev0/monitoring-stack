# Monitoring server ke liye SG
resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring-sg"
  description = "Allow Grafana, Prometheus, Loki"
  vpc_id      = data.aws_vpc.selected.id

  # Grafana (testing ke liye open, prod me apna IP rakhna)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ TODO: prod me apna IP add karo
  }

  # Prometheus UI
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ TODO: restrict in prod
  }

  # Loki UI / API
  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ TODO: restrict in prod
  }

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ TODO: restrict in prod
  }

  # Outbound open
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application instances ke liye SG
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow Node Exporter and Promtail"
  vpc_id      = data.aws_vpc.selected.id

  # Node Exporter (9100) allow only from monitoring server
  ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.monitoring_sg.id]
  }

  # Promtail (9080) allow only from monitoring server
  ingress {
    from_port       = 9080
    to_port         = 9080
    protocol        = "tcp"
    security_groups = [aws_security_group.monitoring_sg.id] # 👈 Added
  }

  # SSH access (for ansible / debugging)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ TODO: restrict in prod
  }

  # Outbound open
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

