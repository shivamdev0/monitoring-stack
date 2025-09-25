# Allow Prometheus (monitoring_sg) to scrape Apache exporter on app servers (9117)
resource "aws_security_group_rule" "allow_monitoring_to_apache_exporter_9117" {
  type                     = "ingress"
  from_port                = 9117
  to_port                  = 9117
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id        # target = app SG
  source_security_group_id = aws_security_group.monitoring_sg.id # source = monitoring SG
  description              = "Allow monitoring_sg to scrape apache_exporter on app servers (9117)"
}



# Allow monitoring server (Loki) to accept pushes from App SG on 3100
resource "aws_security_group_rule" "allow_app_to_loki_3100" {
  type                     = "ingress"
  from_port                = 3100
  to_port                  = 3100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.monitoring_sg.id
  source_security_group_id = aws_security_group.app_sg.id
  description              = "Allow promtail/app_sg to push to Loki on 3100"
}

# Allow monitoring to scrape node exporter from app on 9100 (so monitoring can read Node Exporter)
resource "aws_security_group_rule" "allow_monitoring_to_nodeexporter_9100" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.monitoring_sg.id
  description              = "Allow monitoring_sg to scrape node_exporter on app servers"
}

# If you want Promtail admin port allowed from monitoring (optional)
resource "aws_security_group_rule" "allow_monitoring_to_promtail_9080" {
  type                     = "ingress"
  from_port                = 9080
  to_port                  = 9080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.monitoring_sg.id
  description              = "Allow monitoring_sg to access promtail metrics on app servers"
}

