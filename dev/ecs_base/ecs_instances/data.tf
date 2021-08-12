data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    ecs_config        = var.ecs_config
    ecs_logging       = var.ecs_logging
    cluster_name      = var.cluster
    env_name          = var.environment
    custom_userdata   = var.custom_userdata
    cloudwatch_prefix = var.cloudwatch_prefix
  }
}

# Get latest Linux 2 ECS-optimized AMI by Amazon
data "aws_ami" "latest_ecs_ami" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "amzn2-ami-ecs-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  filter {
    name = "architecture"
    values = [
      "x86_64"]
  }

  owners = [
    "amazon"]
}