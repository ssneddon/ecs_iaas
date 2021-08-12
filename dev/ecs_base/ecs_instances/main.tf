# You can have multiple ECS clusters in the same account with different resources.
# Therefore all resources created here have a name containing the name of the:
# environment, cluster name, and the instance_group name.
# That is also the reason why ecs_instances is a seperate module and not everything is created here.

# Default disk size for Docker is 22 gig, see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
resource "aws_launch_configuration" "launch" {
  name_prefix          = "${var.environment}_${var.cluster}_instance_group"
  image_id             = var.aws_ami != "" ? var.aws_ami : data.aws_ami.latest_ecs_ami.image_id
//  image_id             = data.aws_ami.latest_ecs_ami.image_id
  instance_type        = var.instance_type
  security_groups      = [var.instance_sg_id]
  user_data            = data.template_file.user_data.rendered
  iam_instance_profile = var.iam_instance_profile_name


  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one gets destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 60
  }
}

# Instances are scaled across availability zones http://docs.aws.amazon.com/autoscaling/latest/userguide/auto-scaling-benefits.html 
resource "aws_autoscaling_group" "asg" {
  name                 = "${var.environment}_${var.cluster}_instance_group"
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  force_delete         = true
  launch_configuration = aws_launch_configuration.launch.id
  vpc_zone_identifier  = var.private_subnet_ids

  lifecycle {
    create_before_destroy = true
  }

}




