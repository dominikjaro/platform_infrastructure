module "ec2_app_server" {
  depends_on = [aws_security_group.app-server]

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

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
