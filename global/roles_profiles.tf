//ecs instance role, profile, and policies

# Why we need ECS instance policies http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
# ECS roles explained here http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_managed_policies.html
# Some other ECS policy examples http://docs.aws.amazon.com/AmazonECS/latest/developerguide/IAMPolicyExamples.html

data "aws_iam_policy_document" "ecs_instance_role_trust_policy" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs_instance_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_role_trust_policy.json

  tags               = local.global_tags
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs_instance_profile"
  path = "/"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = aws_iam_role.ecs_instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = aws_iam_role.ecs_instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_sm_role" {
  role       = aws_iam_role.ecs_instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "rexrayPolicyAttachment" {
  role       = aws_iam_role.ecs_instance_role.id
  policy_arn = aws_iam_policy.rexrayPolicy.arn
}

resource "aws_iam_policy" "rexrayPolicy" {
  name = "rexrayPolicy"
  path = "/"
  policy = jsonencode({

    Version: "2012-10-17",
    Statement: [{
    Effect: "Allow",
    Action: [
    "ec2:AttachVolume",
    "ec2:CreateVolume",
    "ec2:CreateSnapshot",
    "ec2:CreateTags",
    "ec2:DeleteVolume",
    "ec2:DeleteSnapshot",
    "ec2:DescribeAvailabilityZones",
    "ec2:DescribeInstances",
    "ec2:DescribeVolumes",
    "ec2:DescribeVolumeAttribute",
    "ec2:DescribeVolumeStatus",
    "ec2:DescribeSnapshots",
    "ec2:CopySnapshot",
    "ec2:DescribeSnapshotAttribute",
    "ec2:DetachVolume",
    "ec2:ModifySnapshotAttribute",
    "ec2:ModifyVolumeAttribute",
    "ec2:DescribeTags"
  ],
    Resource: "*"
  }]

  })
}

//ecs task and task execution roles, profiles, and policies

data "aws_iam_policy_document" "ecs_task_execution_role_trust_policy" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }

}

data "aws_iam_policy_document" "ecs_task_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_trust_policy.json

  tags               = local.global_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
  tags               = local.global_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

// alb roles, profiles, and policies

data "aws_iam_policy_document" "ecs_alb_trust_policy" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_alb_role" {
  name               = "ecs_alb_role"
  path               = "/ecs/"
  assume_role_policy = data.aws_iam_policy_document.ecs_alb_trust_policy.json

  tags               = local.global_tags
}

resource "aws_iam_role_policy_attachment" "ecs_alb" {
  role       = aws_iam_role.ecs_alb_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

//cloudwatch for cloudtrail roles, profiles, and policies

data "aws_iam_policy_document" "cloudtrail_trust_policy" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "cloudtrail_role" {
  name               = "cloudtrail_role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_trust_policy.json

  tags               = local.global_tags
}

resource "aws_iam_role_policy_attachment" cloudtrail-policy-one {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}