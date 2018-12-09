provider "aws" {
  region = "${var.region}"
  alias  = "dummy"
}

data "aws_caller_identity" "current" {
  provider = "aws.dummy"
}

provider "aws" {
  region = "${var.region}"
  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/terraform_aws_permissions_generator_permissions_add_role"
    session_name = "terraform_aws_permissions_generator"
  }
}
