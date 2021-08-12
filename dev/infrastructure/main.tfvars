
# A name to describe the environment we're creating.
environment = "demo"

# a name for tagging the resources created
project = "hhsaspa"

application = "ecsDemo"

# The IP range to attribute to the virtual network.
# The allowed block size is between a /16 (65,536 addresses) and /28 (16 addresses).
vpc_cidr = "10.0.0.0/16"

# The IP ranges to use for the public subnets in your VPC.
# Must be within the IP range of your VPC.
public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

# The IP ranges to use for the private subnets in your VPC.
# Must be within the IP range of your VPC.
private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

# The AWS availability zones to create subnets in.
# For high-availability, we need at least two.
availability_zones = ["us-east-1a", "us-east-1b"]
