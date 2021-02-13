# SRE Challenge

This project is composed by 3 different folders:
- app: Application code
- k8s: Kubernetes configuration (helm and yaml definition)
- infrastructure: Terraform code to deploy infrastructure on AWS

Terraform code contains 4 differents modules:

- Bastion: EC2 with VPN
- EKS: EKS y ECR 
- Network: VPC, Subnets, IGW y NAT.
- Pipeline: CodePipeline and CodeBuild configuration with Github webhook

## Init Terraform

First of all, we will need to init our Terraform modules with the following command:

```
cd infrastructure
terraform init
```

## Apply Terraform

If you want to deploy the whole infrastructure, you will need to execute the following command:

```
terraform apply -var-file=fileenvironment.tfvars
```

If you want to deploy only a module:

```
terraform apply -target module.network -var-file=file.tfvars
```

## Terraform 0.13 Providers

|     Nombre   |   Versión   |
|--------------|-------------|
|     aws      |  ~> 3.27.0  |
|   github     |  ~> 4.4.0   |

## TFvars

|          Nombre           |                        Descripción                              |        Tipo         |
|---------------------------|-----------------------------------------------------------------|---------------------|
|aws_access_key             |AWS access key                                                   |'string'             |
|aws_secret_key             |AWS secret key                                                   |'string'             |
|location                   |Region                                                           |'string'             |
|resource_prefix            |Project identifier                                               |'string'             |
|project                    |Project name                                                     |'string'             |
|environment                |Environment name                                                 |'string'             |
|cidr                       |VPC CIDR                                                         |'string'             |
|availability_zones         |Availability zones count                                         |'number'             |
|instance_type_workers      |EKS Node instance type                                           |'string'             |
|max_workers                |Max nodes number of EKS                                          |'number'             |
|min_workers                |Min nodes number of EKS                                          |'number'             |
|des_workers                |Desired nodes number of EKS                                      |'number'             |
|github_token               |Github authentication generated token                            |'string'             |
|alerting_sms_number        |Telephone number with country code to send sms on alert          |'string'             |


      - echo Deploy to EKS on `date`
      - aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $EKS_CLUSTER --role-arn $KUBECTL_ROLE_ARN
      - kubectl apply --v=4 -f ./k8s/cert-manager.yaml
      - helm upgrade -i cluster-additional-tools ./k8s/cluster-additional-tools --set eksClusterName=$EKS_CLUSTER --set awsDefaultRegion=$AWS_DEFAULT_REGION
      - helm upgrade -i sre-challenge ./k8s/sre-challenge-rest --set eksClusterName=$EKS_CLUSTER --set awsAccountId=$AWS_ACCOUNT_ID /
        --set awsDefaultRegion=$AWS_DEFAULT_REGION --set imageRepoName=$IMAGE_REPO_NAME --set imageTag=$IMAGE_TAG