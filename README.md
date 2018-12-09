# Terraform AWS Permissions Generator

**Warning:** This will launch and destroy all resources defined within your terraform project.
I'd recommend creating a new AWS account to run this.

Terraform AWS Permissions Generator creates an AWS IAM policy containing only the permissions required to launch and destroy resources defined in a terraform project.

It does this by running terraform, then parsing the crash log for the permissions it needs, adding them to a policy, and trying again until terraform completes successfully.

**Disclaimer:** This was just a bit of weekend fun - There's probably much better ways to get a set of permissions. Use at your own risk!

## Quick Start

The AWS account you will be running this against will need bootstrapping to create the required user/roles/policies to allow the generator to run.

To bootstrap the account:

```
cd bootstrap
terraform init
terraform apply -var region=<aws_region>
```

This also places the user credentials and config in the following files, at the root of this repo:

```
terraform_aws_permissions_generator_config
terraform_aws_permissions_generator_user_credentials
```

They need to be there to run the generate script

Some directories in the project need to be initialized, and dependencies installed. You may add terraform backends if you wish. To setup:

```
bundle install
cd policy_modifier
terraform init
cd ..
cd test_resources
terraform init
cd ..
```

You can now run the generate script. This is the point that resources will begin being created and destroyed.

Using `test_resources` as an example, which launches and destroys a `t2.micro` EC2 instance:

```
./generate --region <aws_region> --terraform-path test_resources
```

Once complete, it will output an IAM policy into `completed_policies`

## Usage

```
Usage: generate [options]
    -v TERRAFORM_VAR_FILE,           Terraform variable file
        --var-file
    -r, --region AWS_REGION          AWS Region
    -p TERRAFORM_PATH,               Terraform path
        --terraform-path
    -a, --auto-approve AUTO_APPROVE  Auto approve
```
