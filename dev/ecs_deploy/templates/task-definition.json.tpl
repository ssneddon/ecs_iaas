[
  {
    "name": "${name}-container",
    "image": "${aws_ecr_repository}:${tag}",
    "memory": 2048,
    "cpu": 1024,
    "networkMode": "awsvpc",
    "essential": true,
    "privileged": true,
    "environment": [ {
                          "name": "AWS_DEFAULT_REGION",
                          "value": "us-east-1"
                        },
                        {
                          "name": "SCM_USERNAME",
                          "value": "${scm_username}"
                        },
                        {
                           "name": "SCM_PASSWORD",
                           "value": "${scm_pwd}"
                         },
                          {
                            "name": "CLOUD_ECS_CLUSTER_ARN",
                            "value": "${cluster_arn}"
                          },
                          {
                            "name": "CLOUD_ECS_SECURITY_GROUPS",
                            "value": "${instance_sg}"
                          },
                          {
                            "name": "CLOUD_ECS_SUBNETS",
                            "value": "${instance_subnet}"
                          },
                          {
                            "name": "JENKINS_URL",
                            "value": "http://localhost:8080"
                          }
                        ],
    "portMappings": [
        {
        "containerPort": 8080,
        "hostPort": 8080
        },
        {
        "containerPort": 50000,
        "hostPort": 50000
        }
    ],
    "mountPoints": [
            {
                "containerPath": "/var/jenkins_home",
                "sourceVolume": "jenkins-home"
            },
            {
                "containerPath": "/docker_data",
                "sourceVolume": "docker_data"
            }
    ],
    "ulimits": [
        {
            "name": "nofile",
            "softLimit": 8192,
            "hardLimit": 100000
        }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "555953355165_CloudTrail_us-east-1",
        "awslogs-group": "${project}_${environment}-cloudtrail-cw-logs"
      }
    }
  }
]