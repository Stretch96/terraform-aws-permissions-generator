[default]
region=eu-west-2

[profile generatedpermissions]
source_profile = default
role_arn = ${terraform_aws_permissions_generator_role_arn}
