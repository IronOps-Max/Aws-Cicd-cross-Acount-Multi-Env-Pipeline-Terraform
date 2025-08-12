resource "aws_codedeploy_app" "dev_app" {
  name = var.dev_codedeploy_app
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "dev_deployment_group" {
  app_name              = aws_codedeploy_app.dev_app.name
  deployment_group_name = var.dev_codedeploy_deployment_group

  service_role_arn = aws_iam_role.codepipeline_role.arn

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Environment"
      type  = "KEY_AND_VALUE"
      value = "Dev"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
