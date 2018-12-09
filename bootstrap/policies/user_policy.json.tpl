{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ec2:DescribeAccountAttributes"
            ],
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Resource": "${terraform_aws_permissions_generator_permissions_add_role_arn}"
        }
    ]
}
