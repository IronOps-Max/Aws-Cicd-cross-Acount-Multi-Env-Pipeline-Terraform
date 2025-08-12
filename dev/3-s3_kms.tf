data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid = "AllowAccountAdmins"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "AllowDevRolesToUseKey"
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.pipeline_role_name}",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.codebuild_role_name}",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.dev_codedeploy_app}*"  # if any role for codedeploy
      ]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowProdRolesToUseKey"
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${var.prod_account_id}:role/ProdCrossAccountCodeDeployRole",
        "arn:aws:iam::${var.prod_account_id}:role/ProdEC2CodeDeployRole"
      ]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }
}
