data "aws_caller_identity" "current" {}

resource "aws_iam_role" "prod_cross_account_role" {
  name = var.prod_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::${var.dev_account_id}:role/IronOpsDevCodePipelineRole"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "prod_cross_account_policy" {
  name = "${var.prod_role_name}-policy"
  role = aws_iam_role.prod_cross_account_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision"
        ],
        Resource = [
          "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:application/${var.prod_codedeploy_app}",
          "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deploymentgroup/${var.prod_codedeploy_app}/${var.prod_codedeploy_deployment_group}"
        ]
      }
    ]
  })
}
