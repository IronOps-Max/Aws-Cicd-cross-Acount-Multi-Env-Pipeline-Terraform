resource "aws_codepipeline" "pipeline" {
  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.artifact_kms.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "GitHubSource"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceOutput"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = data.aws_secretsmanager_secret_version.github_token.secret_string
      }

      run_order = 1
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }

      run_order = 1
    }
  }

  stage {
    name = "DeployDev"
    action {
      name            = "DeployDev"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["BuildOutput"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.dev_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.dev_deployment_group.deployment_group_name
      }

      run_order = 1
    }
  }

  stage {
    name = "Approval"
    action {
      name     = "ManualApproval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      run_order = 1
    }
  }

  stage {
    name = "DeployProd"
    action {
      name            = "DeployProd"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["BuildOutput"]
      version         = "1"

      configuration = {
        ApplicationName     = var.prod_codedeploy_app
        DeploymentGroupName = var.prod_codedeploy_deployment_group
      }

      role_arn = var.prod_deploy_role_arn

      run_order = 1
    }
  }
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = var.github_secret_arn
}
