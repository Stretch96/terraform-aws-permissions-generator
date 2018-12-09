# Role to add polcy containing on the fly permissions that the
# terraform_aws_permissions_generator user can assume
data "template_file" "terraform_aws_permissions_generator_role" {
  template = "${file("./policies/assume_roles/terraform_aws_permissions_generator_role.json.tpl")}"

  vars {
    user_arn = "${aws_iam_user.terraform_aws_permissions_generator.arn}"
  }
}

resource "aws_iam_role" "terraform_aws_permissions_generator_role" {
  name               = "terraform_aws_permissions_generator_role"
  assume_role_policy = "${data.template_file.terraform_aws_permissions_generator_role.rendered}"
}

# Role / polciy to allow terraform_aws_permissions_generator to add permissions
# to terraform_aws_permissions_generator_role
data "template_file" "terraform_aws_permissions_generator_permissions_add_role" {
  template = "${file("./policies/assume_roles/terraform_aws_permissions_generator_permissions_add_role.json.tpl")}"

  vars {
    user_arn = "${aws_iam_user.terraform_aws_permissions_generator.arn}"
  }
}

resource "aws_iam_role" "terraform_aws_permissions_generator_permissions_add_role" {
  name               = "terraform_aws_permissions_generator_permissions_add_role"
  assume_role_policy = "${data.template_file.terraform_aws_permissions_generator_permissions_add_role.rendered}"
}

data "template_file" "terraform_aws_permissions_generator_permissions_add_policy" {
  template = "${file("./policies/terraform_aws_permissions_generator_permissions_add_policy.json.tpl")}"

  vars {
    terraform_aws_permissions_generator_role_arn   = "${aws_iam_role.terraform_aws_permissions_generator_role.arn}"
    terraform_aws_permissions_generator_policy_arn = "arn:aws:iam::${local.account_id}:policy/terraform_aws_permissions_generator_permissions_policy"
  }
}

resource "aws_iam_role_policy" "terraform_aws_permissions_generator_permissions_add_policy" {
  name   = "terraform_aws_permissions_generator_permissions_add_policy"
  role   = "${aws_iam_role.terraform_aws_permissions_generator_permissions_add_role.id}"
  policy = "${data.template_file.terraform_aws_permissions_generator_permissions_add_policy.rendered}"
}
