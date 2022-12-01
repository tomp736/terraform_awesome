variable "test_id" {
  description = "(Required) - TestID for testing."
  type        = string
  sensitive   = true
}

variable "github_public_key" {
  description = "(Required) - Public key for testing."
  type        = string
  sensitive   = true
}