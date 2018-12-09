variable "region" {
  description = "AWS Region"
  type        = "string"
}

variable "user_name" {
  description = "Name of AWS user to create"
  default     = "terraform_aws_permissions_generator"
  type        = "string"
}
