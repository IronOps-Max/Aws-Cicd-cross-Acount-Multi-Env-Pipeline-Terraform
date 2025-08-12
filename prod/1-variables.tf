variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "prod_role_name" {
  type    = string
  default = "ProdCrossAccountCodeDeployRole"
}

variable "dev_account_id" {
  type        = string
  description = "Dev AWS Account ID"
}

variable "prod_codedeploy_app" {
  type    = string
  default = "IronOpsProdApp"
}

variable "prod_codedeploy_deployment_group" {
  type    = string
  default = "IronOpsProdDG"
}

variable "prod_ec2_role_name" {
  type    = string
  default = "ProdEC2CodeDeployRole"
}

variable "prod_ec2_instance_profile_name" {
  type    = string
  default = "ProdEC2CodeDeployInstanceProfile"
}

variable "dev_artifact_bucket_arn" {
  type        = string
  description = "ARN of dev artifacts S3 bucket"
}

variable "dev_artifact_bucket_objects_arn" {
  type        = string
  description = "ARN of dev artifacts bucket objects"
}

variable "dev_kms_key_arn" {
  type        = string
  description = "ARN of dev KMS key"
}
