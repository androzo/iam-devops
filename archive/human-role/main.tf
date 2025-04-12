data "aws_iam_policy" "permissions_boundary" {
  arn = "arn:aws:iam::${var.account_number}:policy/${var.team_name}-human-permission-boundary"
}

resource "aws_iam_role" "human_role" {
  name                 = "${var.team_name}-human-role"
  permissions_boundary = data.aws_iam_policy.permissions_boundary.arn

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_number}:saml-provider/entra-id" # Replace with your SAML provider ARN
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.team_name}-human-role"
    team        = var.team_name
    environment = var.environment
  }
}

resource "aws_iam_policy" "human_policy" {
  name        = "${var.team_name}-human-policy"
  description = "Policy granting permissions for human users in team ${var.team_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl",
          "s3:DeleteObjectVersion",
          "s3:GetObjectVersion",
          "s3:PutObjectVersionAcl"
        ]
        Resource = [
          "arn:aws:s3:::${var.team_name}-*",
          "arn:aws:s3:::${var.team_name}-*/*"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.team_name}-human-role-policy"
    team        = var.team_name
    environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "attach_human_policy" {
  role       = aws_iam_role.human_role.name
  policy_arn = aws_iam_policy.human_policy.arn

  depends_on = [
    aws_iam_role.human_role,
    aws_iam_policy.human_policy
  ]
}
