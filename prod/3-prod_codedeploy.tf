resource "aws_codedeploy_app" "prod_app" {
  name             = var.prod_codedeploy_app
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "prod_deployment_group" {
  app_name              = aws_codedeploy_app.prod_app.name
  deployment_group_name = var.prod_codedeploy_deployment_group

  service_role_arn = aws_iam_role.prod_cross_account_role.arn

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Environment"
      type  = "KEY_AND_VALUE"
      value = "Prod"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
