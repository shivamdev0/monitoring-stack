# IAM Role for Grafana/CloudWatch
resource "aws_iam_role" "grafana_role" {
  name = "grafana-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach CloudWatch ReadOnly policy
resource "aws_iam_role_policy_attachment" "grafana_cloudwatch_attach" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# IAM Instance Profile (required for EC2)
resource "aws_iam_instance_profile" "grafana_profile" {
  name = "grafana-cloudwatch-profile-v1"
  role = aws_iam_role.grafana_role.name
}

