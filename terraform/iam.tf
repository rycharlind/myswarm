# # Create IAM Role for Terraform Execution
# resource "aws_iam_role" "terraform_execution_role" {
#   name = "TerraformExecutionRole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # Attach Policies to the Terraform Execution Role
# resource "aws_iam_policy" "vpc_management_policy" {
#   name = "VpcManagementPolicy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:CreateVpc",
#           "ec2:DeleteVpc",
#           "ec2:DescribeVpcs",
#           "ec2:CreateSubnet",
#           "ec2:DeleteSubnet",
#           "ec2:DescribeSubnets",
#           "ec2:CreateNatGateway",
#           "ec2:DescribeNatGateways",
#           "ec2:AllocateAddress",
#           "ec2:ReleaseAddress",
#           "ec2:CreateInternetGateway",
#           "ec2:DeleteInternetGateway",
#           "ec2:AttachInternetGateway",
#           "ec2:CreateRouteTable",
#           "ec2:AssociateRouteTable",
#           "ec2:CreateRoute",
#           "ec2:DescribeRouteTables",
#           "ec2:CreateSecurityGroup",
#           "ec2:AuthorizeSecurityGroupIngress",
#           "ec2:AuthorizeSecurityGroupEgress",
#           "ec2:DeleteSecurityGroup",
#           "ec2:DescribeSecurityGroups"
#         ],
#         Effect = "Allow",
#         Resource = "*"
#       }
#     ]
#   })
# }