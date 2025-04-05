resource "aws_iam_role" "human_role" {
  name = "${var.team_name}-human-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::396608777381:saml-provider/entra-id" # Replace with your SAML provider ARN
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
    Team        = var.team_name
    Environment = "devl"
  }
}

resource "aws_iam_policy" "human_policy" {
  name        = "${var.team_name}-human-policy"
  description = "Policy granting permissions for human users in team ${var.team_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:Describe*",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = [
          "arn:aws:s3:::team-anders-*",
          "arn:aws:s3:::team-anders-*/*"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.team_name}-human-role-policy"
    Team        = var.team_name
    Environment = "devl"
  }
}

resource "aws_iam_role_policy_attachment" "attach_human_policy" {
  role       = aws_iam_role.human_role.name
  policy_arn = aws_iam_policy.human_role_policy.arn
  depends_on = [ aws_iam_policy.human_policy ]
}