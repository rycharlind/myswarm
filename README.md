# MySwarm

## Install Deps
`poetry install`

## Add Deps
`poetry add <dep>`

## Generate `requirements.txt`
`poetry export -f requirements.txt --output requirements.txt`

## Docker 
Build: `docker build -t myswarm:latest .`

## AWS ECR
```shell
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 408545242574.dkr.ecr.us-east-2.amazonaws.com

docker build -t myswarm .

# Run it and view stdout at same time
docker run -it myswarm:latest

## Build and push for multi platform
docker buildx create --use
docker buildx build --platform linux/amd64 --push -t 408545242574.dkr.ecr.us-east-2.amazonaws.com/myswarm:latest .


docker tag myswarm:latest 408545242574.dkr.ecr.us-east-2.amazonaws.com/myswarm:latest

docker push 408545242574.dkr.ecr.us-east-2.amazonaws.com/myswarm:latest
```

## Remove Image
`docker rmi 408545242574.dkr.ecr.us-east-2.amazonaws.com/my-eks-app-repo/myswarm:latest`

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 408545242574.dkr.ecr.us-east-2.amazonaws.com/my-eks-app-repo

## AWS EKS
`aws eks list-clusters`

## AWS EKS with Terraform

To create an EKS cluster using Terraform:

1. Ensure Terraform is installed.
2. Initialize Terraform: `terraform init`
3. Review planned changes: `terraform plan`
4. Create the EKS cluster: `terraform apply`

To destroy the cluster when no longer needed:
```
terraform destroy
```

aws eks --region us-east-2 update-kubeconfig --name my-eks-cluster

aws eks describe-cluster --name my-eks-cluster --region us-east-2 --query "cluster.resourcesVpcConfig.endpointPublicAccess"

## Kubernetes
- `kubectl cluster-info`
- `kubectl apply -f k8s.template.yml`

aws eks describe-cluster --name my-eks-cluster --query cluster.endpoint --output text

https://99AE5EE104269E53F990D43071B84B37.gr7.us-east-2.eks.amazonaws.com

## AWS Access
Go to EKS Cluster -> Access -> Create access entry -> Add user -> Assign AmazonEKSClusterAdminPolicy policy to that user

kubectl get nodes -o wide

aws ec2 describe-instances --filters "Name=tag:eks:my-eks-cluster,Values=your-cluster-name" --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]" --output table


docker buildx build --platform linux/amd64,linux/arm64 -t my-image:latest .

## ZSH Plugins:
https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins

## Scale Deployment Down
`kubectl scale deployment myswarm-deployment --replicas=0`

## Kubernet Cluster Context
- `kubectl config get-contexts`
- `kubectl config use-context minikube`
- `kubectl config use-context docker-desktop`
- `kubectl config current-context`

## Local Docker Registry 
NOTE: This is only if you are using "minikube". If you are using "docker-desktop", then you can just point directly do your image in the Deployment.
- `docker run -d -p 5300:5000 --restart=always --name registry registry:2`
- `docker build -t myswarm .`
- `docker tag myswarm:latest localhost:5000/myswarm:latest`
- `docker push localhost:5000/myswarm:latest`
- `kubectl apply -f k8s.local.template.yml`
- `kubectl scale deployment myswarm-deployment --replicas=0`