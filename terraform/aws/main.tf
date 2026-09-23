#######
# Roles
#######
resource "aws_iam_role" "app-server-role" {
  name = "app-server-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "policy-attach-ssm" {
  role       = aws_iam_role.app-server-role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}
resource "aws_iam_role_policy_attachment" "policy-attach-ecr-full" {
  role       = aws_iam_role.app-server-role.name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn
}
resource "aws_iam_instance_profile" "app-server-role" {
  name = "app-server-role"
  role = aws_iam_role.app-server-role.name
}

resource "aws_iam_role" "gitlab-runner-role" {
  name = "gitlab-runner-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "policy-attach-ssm-gitlab" {
  role       = aws_iam_role.gitlab-runner-role.name
  policy_arn = data.aws_iam_policy.AmazonSSMFullAccess.arn
}
resource "aws_iam_role_policy_attachment" "policy-attach-ecr-full-gitlab" {
  role       = aws_iam_role.gitlab-runner-role.name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn
}
resource "aws_iam_instance_profile" "gitlab-runner-role" {
  name = "gitlab-runner-role"
  role = aws_iam_role.gitlab-runner-role.name
}

#######################
#NETWORKING RESOURCES #
#######################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "main"

  cidr            = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  azs = data.aws_availability_zones.available.names

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    terraform   = "true"
    environment = var.env_prefix
  }
}
resource "aws_security_group" "main" {
  name   = "main"
  vpc_id = data.aws_vpc.main.id

  ingress {
    description = "Allow inbound from all 10.0.0.0/16"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main"
  }
}
resource "aws_security_group" "app-server" {
  name   = "app-server"
  vpc_id = data.aws_vpc.main.id

  ingress {
    description = "Allow inbound from all 10.0.0.0/16"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "Allow inbound from 0.0.0.0/0"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-server"
  }
}
######
# EC2
######

module "ec2_app_server" {
  depends_on = [aws_security_group.app-server]
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "5.2.1"

  name = "app-server"

  instance_type               = "t3.small"
  availability_zone           = element(data.aws_availability_zones.available.names, 0)
  ami                         = data.aws_ami.ubuntu.id
  iam_instance_profile        = data.aws_iam_instance_profile.app-server-role.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app-server.id]
  subnet_id                   = module.vpc.public_subnets[0]
  user_data                   = base64encode(local.script)

  tags = {
    Terraform   = "true"
    Environment = var.env_prefix
    Name        = "app-server"
  }

  root_block_device = [{
    volume_type           = "gp3"
    volume_size           = 16
    delete_on_termination = true
  }]
}
module "ec2_gitlab_runner" {
  depends_on = [aws_security_group.main]
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "5.2.1"

  name = "gitlab-runner"

  instance_type               = "t3.small"
  availability_zone           = element(data.aws_availability_zones.available.names, 0)
  ami                         = data.aws_ami.ubuntu.id
  iam_instance_profile        = data.aws_iam_instance_profile.gitlab-runner-role.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.main.id]
  subnet_id                   = module.vpc.public_subnets[0]
  user_data                   = base64encode(local.script-gitlab)

  tags = {
    Terraform   = "true"
    Environment = var.env_prefix
    Name        = "gitlab-runner"
  }

  root_block_device = [{
    volume_type           = "gp3"
    volume_size           = 24
    delete_on_termination = true
  }]
}
