variable "aws_region" { type = string, default = "us-east-1" }

variable "artifact_bucket_name" { type = string, default = "ironops-dev-artifacts-bucket" }

variable "kms_key_alias" { type = string, default = "alias/ironops-dev-kms-key" }

variable "codepipeline_name" { type = string, default = "ironops-dev-pipeline" }
variable "pipeline_role_name" { type = string, default = "IronOpsDevCodePipelineRole" }
variable "codebuild_role_name" { type = string, default = "IronOpsDevCodeBuildRole" }
variable "codebuild_project_name" { type = string, default = "IronOpsDevCodeBuildProject" }
variable "codebuild_image" { type = string, default = "aws/codebuild/standard:5.0" }

variable "github_owner" { type = string, default = "ironops-max" }
variable "github_repo" { type = string, default = "Aws-Cicd-cross-Acount-Multi-Env-Pipeline-Terraform" }
variable "github_branch" { type = string, default = "dev" }
variable "github_secret_arn" { type = string, description = "ARN of Secrets Manager secret with GitHub OAuth token" }

variable "dev_codedeploy_app" { type = string, default = "IronOpsDevApp" }
variable "dev_codedeploy_deployment_group" { type = string, default = "IronOpsDevDG" }

variable "prod_account_id" { type = string, description = "Prod AWS Account ID" }
variable "prod_deploy_role_arn" { type = string, description = "ARN of role in Prod that Dev pipeline assumes for deployment" }

variable "prod_codedeploy_app" { type = string, default = "IronOpsProdApp" }
variable "prod_codedeploy_deployment_group" { type = string, default = "IronOpsProdDG" }
