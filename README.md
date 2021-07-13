# 04 ECS

ECS cluster 
launch type - FARGATE

## Used resources

terraform modules from https://github.com/SebastianUA/terraform.git

Great thanks to Vitaliy Natarov!

## AWS CREDENTIALS

```
aws configure
```

## Terrfaorm

```
terraform init
terrafrom plan
terrafrom apply
terraform destroy
```

# a new version of task definition

```
cd ../../04_ECR/Docker-test

docker build --file Dockerfile.v2 --rm --tag {aws_ecr_repository_url}:1.21.1-2 .

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin {aws_ecr_repository_url}

docker push {aws_ecr_repository_url}:1.21.1-2
docker push 957077925602.dkr.ecr.us-east-1.amazonaws.com/leodorov-ecr-l1:1.21.1-2
```