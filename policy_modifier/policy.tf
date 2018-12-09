data "template_file" "terraform_aws_permissions_generator_permissions_policy" {
  template = "${file("../required_permissions.json")}"
}

resource "aws_iam_policy" "terraform_aws_permissions_generator_permissions_policy" {
  name   = "terraform_aws_permissions_generator_permissions_policy"
  policy = "${data.template_file.terraform_aws_permissions_generator_permissions_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "terraform_aws_permissions_generator_role_policy" {
  role       = "terraform_aws_permissions_generator_role"
  policy_arn = "${aws_iam_policy.terraform_aws_permissions_generator_permissions_policy.arn}"
}
