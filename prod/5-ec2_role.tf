resource "aws_iam_role" "prod_ec2_role" {
  name = var.prod_ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "prod_ec2_policy" {
  name = "${var.prod_ec2_role_name}-policy"
  role = aws_iam_role.prod_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        Resource = var.dev_artifact_bucket_objects_arn
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ],
        Resource = var.dev_kms_key_arn
      },
      {
        Effect = "Allow",
        Action = [
          "codedeploy:PollHostCommand",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentInstance",
          "codedeploy:PutLifecycleEventHookExecutionStatus"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "prod_ec2_instance_profile" {
  name = var.prod_ec2_instance_profile_name
  role = aws_iam_role.prod_ec2_role.name
}
