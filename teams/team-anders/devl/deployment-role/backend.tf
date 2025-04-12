terraform {
  backend "s3" {
    bucket               = "androzo-terraform-tfstate" # Replace with your S3 bucket name
    key                  = "deployment-role.tfstate"   # Path to the state file
    workspace_key_prefix = "team-anders/devl/"         # Prefix for workspaces
    region               = "sa-east-1"
    encrypt              = true
  }
}

