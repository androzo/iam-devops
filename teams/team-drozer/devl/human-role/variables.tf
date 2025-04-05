variable "aws_region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = "sa-east-1"
}

variable "team_name" {
  description = "The name of the team."
  type        = string
  default     = "team-drozer"
}