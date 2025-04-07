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

variable "team_account" {
  description = "The AWS account ID of the team."
  type        = string
  default     = "396608777381"
}

variable "environment" {
  description = "The environment to deploy the resources in."
  type        = string
  default     = "devl"
}
