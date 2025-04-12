module "iam_permission_boundary" {
  source        = "git::https://github.com/androzo/iam-permission-boundaries.git//modules/permission-boundary?ref=main"
  team          = var.team_name
  boundary_type = "human"
}

resource "aws_iam_role" "human_role" {
  name                 = "${var.team_name}-human-role"
  permissions_boundary = module.iam_permission_boundary.policy_arn

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

  lifecycle {
    ignore_changes = [permissions_boundary]
  }

  tags = {
    Name = "${var.team_name}-human-role"
    # team        = var.team_name
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
          "ec2:Describe*",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:RequestTag/team" = var.team_name
          }
        }
      },
      {
        Effect = "Allow"
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::${var.team_name}-*",
          "arn:aws:s3:::${var.team_name}-*/*"
        ],
        Condition = {
          StringEquals = {
            "aws:RequestTag/team" = var.team_name
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.team_name}-human-role-policy"
    # team        = var.team_name
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
