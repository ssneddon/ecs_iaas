// security group for efs

resource "aws_security_group" "efs" {
  name        = "${var.project}_${var.environment}_efs_sg"
  description = "enable efs access via port 2049"
  vpc_id = module.network.vpc_id
  tags = local.project_tags
}

resource "aws_security_group_rule" "efs_ingress" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.efs.id
  source_security_group_id = aws_security_group.ecs_tasks.id
}


//security group for alb

resource "aws_security_group" "alb" {
  name        = "${var.project}_${var.environment}_alb_sg"
  description = "controls access to the ALB"
  vpc_id = module.network.vpc_id
  tags = local.project_tags
}

resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

//security group for ecs tasks

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project}_${var.environment}_ecs_tasks_sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = module.network.vpc_id
  tags = local.project_tags

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//security group for ecs instances

resource "aws_security_group" "ecs_instances" {
  name        = "${var.project}_${var.environment}_ecs_instances_sg"
  description = "Used in ${var.environment}"
  vpc_id      = module.network.vpc_id

  tags = local.project_tags
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_instances.id
}

resource "aws_security_group_rule" "inbound_alb_access" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id       = aws_security_group.alb.id
  security_group_id = aws_security_group.ecs_instances.id
}

resource "aws_security_group_rule" "inbound_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  source_security_group_id = aws_security_group.alb.id
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_instances.id
}