##################
# app-server Role
##################
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
# attach the needed policies to the created ec2 role
resource "aws_iam_role_policy_attachment" "policy-attach-ssm" {
  role       = aws_iam_role.app-server-role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_role_policy_attachment" "policy-attach-ecr-full" {
  role       = aws_iam_role.app-server-role.name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn
}
# define instance profile, so we can assign the role to our ec2 instance
resource "aws_iam_instance_profile" "app-server-role" {
  name = "app-server-role"
  role = aws_iam_role.app-server-role.name
}

##################
# gitlab-runner Role
##################
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
