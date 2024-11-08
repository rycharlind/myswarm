provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "my-eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  manage_default_network_acl = false
  default_network_acl_tags   = { Name = "${local.name}-default" }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.24"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 50
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.node_group_one.id]
  }

  eks_managed_node_groups = {
    node_group_1 = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = module.eks.cluster_name
  addon_name   = "eks-pod-identity-agent"

  addon_version = "v1.0.0-eksbuild.1"  // Use the latest version available

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_name
  addon_name   = "kube-proxy"

  addon_version = "v1.24.10-eksbuild.2"  // Make sure this matches your EKS version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version = "2.0.0"

  repository_name = "my-eks-app-repo"
  repository_type = "private"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "any",
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Environment = "dev"
    Project     = "my-eks-app"
  }
}

resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapUsers = yamlencode([
#       {
#         userarn  = "arn:aws:iam::408545242574:user/my-dev-user"
#         username = "my-dev-user"
#         groups   = ["system:masters"]
#       }
#     ])
#   }

#   depends_on = [module.eks]
# }


# resource "kubernetes_role" "developer" {
#   metadata {
#     name = "developer"
#     namespace = "kube-system"
#   }

#   rule {
#     api_groups = ["", "apps", "batch", "extensions"]
#     resources  = ["*"]
#     verbs      = ["get", "list", "watch"]
#   }
# }

# resource "kubernetes_role_binding" "developer" {
#   metadata {
#     name = "developer-binding"
#     namespace = "kube-system"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.developer.metadata[0].name
#   }

#   subject {
#     kind      = "User"
#     name      = "my-dev-user"
#     api_group = "rbac.authorization.k8s.io"
#   }
# }