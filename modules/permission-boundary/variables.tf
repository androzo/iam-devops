variable "team" {
  description = "Team name to scope resources"
  type        = string
}

variable "boundary_type" {
  description = "Type of boundary: 'deployment' or 'human'"
  type        = string
  validation {
    condition     = contains(["deployment", "human"], var.boundary_type)
    error_message = "boundary_type must be 'deployment' or 'human'"
  }
}
