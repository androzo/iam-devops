terraform {
  backend "s3" {
    bucket               = "androzo-terraform-tfstate" # Replace with your S3 bucket name
    key                  = "human-role.tfstate"        # Path to the state file
    workspace_key_prefix = "team-anders"               # Prefix for workspaces
    region               = "sa-east-1"
    encrypt              = true
  }
}

