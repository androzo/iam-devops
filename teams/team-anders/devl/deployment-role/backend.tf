terraform {
  backend "s3" {
    bucket         = "androzo-terraform-state" # Replace with your S3 bucket name
    key            = "devl/team-anders/deployment-role/terraform.tfstate" # Path to the state file
    region         = "sa-east-1"
    encrypt        = true              
  }
}