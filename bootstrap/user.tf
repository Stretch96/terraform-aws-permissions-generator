# Create user
resource "aws_iam_user" "terraform_aws_permissions_generator" {
  name = "${var.user_name}"
}

# Create user policy
# Needed to run some terraform actions before assuming role
data "template_file" "user_policy" {
  template = "${file("./policies/user_policy.json.tpl")}"

  vars {
    terraform_aws_permissions_generator_permissions_add_role_arn = "${aws_iam_role.terraform_aws_permissions_generator_permissions_add_role.arn}"
  }
}

resource "aws_iam_user_policy" "terraform_aws_permissions_generator" {
  name   = "terraform_aws_permissions_generator"
  user   = "${aws_iam_user.terraform_aws_permissions_generator.name}"
  policy = "${data.template_file.user_policy.rendered}"
}

# Create access key
resource "aws_iam_access_key" "terraform_aws_permissions_generator" {
  user = "${aws_iam_user.terraform_aws_permissions_generator.name}"
}

# Store credentials
data "template_file" "user_credentials" {
  template = "${file("./templates/aws_credentials.tpl")}"

  vars {
    aws_access_key_id                            = "${aws_iam_access_key.terraform_aws_permissions_generator.id}"
    aws_secret_access_key                        = "${aws_iam_access_key.terraform_aws_permissions_generator.secret}"
  }
}

data "template_file" "config" {
  template = "${file("./templates/aws_config.tpl")}"

  vars {
    terraform_aws_permissions_generator_role_arn = "${aws_iam_role.terraform_aws_permissions_generator_role.arn}"
  }
}

resource "local_file" "credentials" {
  content  = "${data.template_file.user_credentials.rendered}"
  filename = "../terraform_aws_permissions_generator_user_credentials"

  provisioner "local-exec" {
    command = "chmod 400 ../terraform_aws_permissions_generator_user_credentials"
  }
}

resource "local_file" "config" {
  content  = "${data.template_file.config.rendered}"
  filename = "../terraform_aws_permissions_generator_config"

  provisioner "local-exec" {
    command = "chmod 400 ../terraform_aws_permissions_generator_config"
  }
}
