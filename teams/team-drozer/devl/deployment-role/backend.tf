terraform {
  backend "s3" {
    bucket         = "androzo-terraform-tfstate" # Replace with your S3 bucket name
    key            = "devl/${var.team_name}/deployment-role/terraform.tfstate" # Path to the state file
    region         = var.aws_region
    encrypt        = true              
  }
}