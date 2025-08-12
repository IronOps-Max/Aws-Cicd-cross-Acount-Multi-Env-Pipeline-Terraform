data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "AllowDevRolesFullAccess"
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.pipeline_role_name}",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.codebuild_role_name}",
        # Add any other dev roles that need access here
      ]
    }
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.artifact_bucket.arn,
      "${aws_s3_bucket.artifact_bucket.arn}/*"
    ]
  }

  statement {
    sid = "AllowProdRolesReadArtifacts"
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${var.prod_account_id}:role/ProdCrossAccountCodeDeployRole",
        "arn:aws:iam::${var.prod_account_id}:role/ProdEC2CodeDeployRole"
      ]
    }
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "${aws_s3_bucket.artifact_bucket.arn}/*"
    ]
  }
}
