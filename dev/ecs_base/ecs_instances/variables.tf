variable "environment" {
  description = "The name of the environment"
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

variable "cluster" {
  description = "The name of the cluster"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "aws_ami" {
  description = "The AWS ami id to use"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type to use"
}

variable "max_size" {
  default     = 1
  description = "Maximum size of the nodes in the cluster"
}

variable "min_size" {
  default     = 1
  description = "Minimum size of the nodes in the cluster"
}

#For more explenation see http://docs.aws.amazon.com/autoscaling/latest/userguide/WhatIsAutoScaling.html
variable "desired_capacity" {
  default     = 1
  description = "The desired capacity of the cluster"
}

variable "iam_instance_profile_name" {
  description = "The name of the instance profile that should be used for the instances"
}

variable "private_subnet_ids" {
  type        = list
  description = "The list of private subnets to place the instances in"
}

//variable "depends_id" {
//  description = "Workaround to wait for the NAT gateway to finish before starting the instances"
//}

variable "custom_userdata" {
//  default     = "\nsudo mkdir /docker_data\nsudo mount /dev/svg /docker_data\nexec 2>>/var/log/ecs_deploy/ecs_deploy-agent-install.log\nset -x\nuntil curl -s http://localhost:51678/v1/metadata\ndo\n\\sleep 1\ndone\ndocker plugin install rexray/ebs REXRAY_PREEMPT=trueEBS_REGION=us-east-1 --grant-all-permissions\nstop ecs_deploy \nstart ecs_deploy\n"
//  default     = "\nsudo mkdir /docker_data\nsudo mount /dev/svg /docker_data"
  description = "Inject extra command in the instance template to be run on boot"
}

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "project_tags" {
  description = "project tags"
}

variable "instance_sg_id" {
  description = "the sg of the ecs ec2 instances"
}
