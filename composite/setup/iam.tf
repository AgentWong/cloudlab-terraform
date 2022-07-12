resource "aws_iam_role" "ansible_inventory_role" {
  name = "ansible_inventory_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "ansible_inventory_profile" {
  name = "ansible_inventory_profile"
  role = aws_iam_role.ansible_inventory_role.name
}
resource "aws_iam_role_policy" "ansible_inventory_policy" {
  name = "ansible_inventory_policy"
  role = aws_iam_role.ansible_inventory_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeImages",
        "ec2:DescribeTags", 
        "ec2:DescribeSnapshots"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
