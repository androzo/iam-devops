locals {
  name = "${var.team}-${var.boundary_type}-permission-boundary"
}

resource "aws_iam_policy" "boundary" {
  name        = local.name
  path        = "/permission-boundaries/"
  description = "Permissions boundary for ${var.boundary_type} roles"

  policy = templatefile("${path.module}/policies/${var.boundary_type}.json", {
    team = var.team
  })

  tags = {
    Name = local.name
    Team = "devops"
  }
}
