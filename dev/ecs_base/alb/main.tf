resource "aws_alb" "alb" {
  name               = "${var.project}-${var.environment}-alb"
  subnets            = var.public_subnet_ids
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]

  tags = var.project_tags
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "redirect"

    redirect {
      status_code = "HTTP_301"
      port        = "443"
      protocol    = "HTTPS"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_cert_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default.arn
  }
}

resource "aws_alb_target_group" "default" {
  name        = "${var.project}-${var.environment}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/login"
    unhealthy_threshold = "2"
  }

  tags = var.project_tags
}


