{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "iam:AttachRolePolicy",
              "iam:DetachRolePolicy",
              "iam:GetRole",
              "iam:ListAttachedRolePolicies"
            ],
            "Resource": "${terraform_aws_permissions_generator_role_arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
              "iam:CreatePolicy",
              "iam:CreatePolicyVersion",
              "iam:DeletePolicy",
              "iam:DeletePolicyVersion",
              "iam:GetPolicy",
              "iam:GetPolicyVersion", 
              "iam:ListPolicyVersions"
            ],
            "Resource": "${terraform_aws_permissions_generator_policy_arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
              "ec2:DescribeAccountAttributes"
            ],
            "Resource": "*"
        }
    ]
}
