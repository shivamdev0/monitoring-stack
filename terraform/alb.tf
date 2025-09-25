# terraform/alb.tf
########################
# Application Load Balancer + Target Group (only Grafana) + Listener + Attachment
########################

resource "aws_lb" "monitoring_alb" {
  name                       = "monitoring-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_sg.id]
  subnets                    = data.aws_subnets.selected.ids
  enable_deletion_protection = false

  tags = {
    Name = "monitoring-alb"
  }
}

# -----------------
# Target group for Grafana
# -----------------
resource "aws_lb_target_group" "grafana_tg" {
  name        = "tg-grafana"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
  target_type = "instance"

  health_check {
    path                = "/api/health"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = "traffic-port"
  }
}

# -----------------
# Listener (HTTP 80) - default forward to Grafana
# -----------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.monitoring_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}

# -----------------
# Optional path rule: /grafana → Grafana TG
# -----------------
resource "aws_lb_listener_rule" "grafana_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
  condition {
    path_pattern {
      values = ["/grafana/*", "/grafana"]
    }
  }
}

# -----------------
# Attach monitoring instance to Grafana TG
# -----------------
resource "aws_lb_target_group_attachment" "grafana_attach" {
  depends_on       = [aws_instance.monitoring]
  target_group_arn = aws_lb_target_group.grafana_tg.arn
  target_id        = aws_instance.monitoring.id
  port             = 3000
}

