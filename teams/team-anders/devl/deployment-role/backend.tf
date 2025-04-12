terraform {
  backend "s3" {
    bucket               = "androzo-terraform-tfstate"           # Replace with your S3 bucket name
    key                  = "team-anders/deployment-role.tfstate" # Path to the state file in the folder
    workspace_key_prefix = "team-anders"                         # Prefix for workspaces
    region               = "sa-east-1"
    encrypt              = true
  }
}

