module "iam_permission_boundary" {
  source        = "git::https://github.com/androzo/iam-permission-boundaries.git//modules/permission-boundary?ref=main"
  team          = var.team_name
  boundary_type = "deployment"
}

resource "aws_iam_role" "deployment_role" {
  name                 = "${var.team_name}-deployment-role"
  permissions_boundary = module.iam_permission_boundary.policy_arn

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.account_number}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:androzo/${var.team_name}-*/environment:${var.environment}"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.team_name}-deployment-role"
    team        = "devops"
    environment = var.environment
  }
}

resource "aws_iam_policy" "deployment_policy" {
  name        = "${var.team_name}-deployment-policy"
  description = "Policy granting access to resources tagged with Team=${var.team_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestTag/team" = var.team_name
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "*"
        Condition = {
          StringEquals = {
            "s3:ResourceTag/team" = var.team_name
          }
        }
      }
    ]
  })

  depends_on = [module.iam_permission_boundary]

  tags = {
    Name        = "${var.team_name}-deployment-policy"
    team        = "devops"
    environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "attach_deployment_policy" {
  role       = aws_iam_role.deployment_role.name
  policy_arn = aws_iam_policy.deployment_policy.arn
  depends_on = [aws_iam_policy.deployment_policy]
}
