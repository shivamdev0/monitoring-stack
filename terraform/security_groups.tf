# ALB SG
resource "aws_security_group" "lb_sg" {
  name        = "monitoring-lb-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
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

# Monitoring SG (no reference to app_sg here)
resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring-sg"
  description = "Allow Grafana from ALB; keep Prometheus/Loki private"
  vpc_id      = data.aws_vpc.selected.id

  # Allow Grafana access from ALB only (we keep this here because it references lb_sg? 
  # To avoid cycle also safe to move to aws_security_group_rule, but referencing lb_sg here is okay because lb_sg does not reference monitoring_sg)
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  # SSH - restrict to your IP (replace x.x.x.x/32)
  ingress {
    from_port   = 22
    to_port     = 22
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

# App SG (no reference to monitoring_sg inside)
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow Node Exporter and Promtail"
  vpc_id      = data.aws_vpc.selected.id

  # SSH - restrict in prod (left as CIDR for now if needed)
  ingress {
    from_port   = 22
    to_port     = 22
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

