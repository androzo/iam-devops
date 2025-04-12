terraform {
  backend "s3" {
    bucket  = "androzo-terraform-tfstate"                     # Replace with your S3 bucket name
    key     = "team-drozer/deployment-role/terraform.tfstate" # Path to the state file
    region  = "sa-east-1"
    encrypt = true
  }
}
