# Recurso do Load Balancer
resource "aws_lb" "app_lb" {
  name               = "${var.project}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ports.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]

  enable_deletion_protection = false
  idle_timeout               = 400
  drop_invalid_header_fields = true
  enable_http2               = true

  tags = {
    Name = "${var.project}-load-balancer"
  }
}

# Recurso do Listener HTTPS
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Recurso do Target Group
resource "aws_lb_target_group" "target_group" {
  name     = "${var.project}-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.main.id

  health_check {
    port                = 80
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher = "200,400"
  }

  tags = {
    Name = "${var.project}-target-group"
  }
}

# Recurso de Registro do Target Group
resource "aws_lb_target_group_attachment" "app_instance" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.ec2_instance.id
  port             = 443
}
