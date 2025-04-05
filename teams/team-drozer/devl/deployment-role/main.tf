resource "aws_iam_role" "deployment_role" {
  name = "${var.team_name}-deployment-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::396608777381:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:androzo/${var.team_name}-*:*"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.team_name}-deployment-role"
    Team        = var.team_name
    Environment = "devl"
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
            "aws:RequestTag/Team" = var.team_name
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "*"
        Condition = {
          StringEquals = {
            "s3:ResourceTag/Team" = var.team_name
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.team_name}-deployment-policy"
    Team        = var.team_name
    Environment = "devl"
  }
}

resource "aws_iam_role_policy_attachment" "attach_deployment_policy" {
  role       = aws_iam_role.deployment_role.name
  policy_arn = aws_iam_policy.deployment_policy.arn
  depends_on = [ aws_iam_policy.deployment_policy ]
}