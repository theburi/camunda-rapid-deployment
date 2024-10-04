# camunda-rapid-deployment
Demo for CamundaCon New York 2024

# First demo is a demo of EKS and Camunda Helm deployment with Terraform


## Let me introduce my set up and assumption

For simplicity I am running something very simple. We assume some knowledge of IaC knowledge, but we will do our best to explain principles.
What you will not see:
* EKS is deployed simply- without Vault, IAM service accounts, Ingresses or TLS 
* GitHub Actions: Many standard processes are omitted to make this presentation more readable: style checks, PR Actions.
* Camunda Deployment we are going to how excludes TLS and Identity configuration, included in the production guide,  so we can show configuration on one page.

Of cource we will have actions for each pull request to veryfy code formatting, Unit Tests, etc etc

I took Camunda AWS EKS guide and created Terraform actions 'terraform.yaml' the only change I made is to save state in S3. 
https://github.com/camunda/camunda-tf-eks-module
I also create IAM user and with OIDC granted access to GitHub Actions execution.

Lets talk about this set up.
1. GitHub Actions
    - infrastructure-create.yml and infrastructure-destroy.yml - Deploy EKS and Camunda 8
    - deploy-pipeline.yml - Deploy my project
2. Credit card payment project: (following getting-started )
    Every time we check in code into ths project we will deploy it to the EKS cluster and execute tests. 
    Of course we can follow with CD principles and deploy with another workflow and deploy to production,
    Note: We can manage worflow independently to Java Project and deploy to Camunda 8 independetly every time it get updated. With New Modeler buinsess people can update workflows and this demo can show that it is possilbe to run Full test suite before deploying to production. See more 8.6 release notes, Git Sync and Play GA Release.

For simplicity we do not show a full test suit and just run one test example to reduce run duration for this demo.

Add IAM access Entry
aws eks create-access-entry --cluster-name demo-cluster-name --region eu-west-1  --principal-arn arn:aws:iam::123302325581:role/aws-reserved/sso.amazonaws.com/eu-central-1/AWSReservedSSO_SystemAdministrator_3272c85503826b83 --type STANDARD 

aws eks associate-access-policy --cluster-name demo-cluster-name --principal-arn arn:aws:iam::123302325581:role/aws-reserved/sso.amazonaws.com/eu-central-1/AWSReservedSSO_SystemAdministrator_3272c85503826b83 --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy --access-scope type=cluster --region eu-west-1


Create new EKS context `aws eks --region eu-west-1 update-kubeconfig --name demo-cluster-name`


### Demo on the environment:
1. Show Operate version
2. you can see existing Guids how to deploy Full stack Orchestrtaion platform. I would demo how to update it if you are using 'IaC'.
We have deployed EKS and Helm 8.4 and now we would like to update to 8.5
lets review files and switch to our provided 8.5 values, check in and submit.
3. You will see Github Actions run and in 3 min Camunda will upgrade
    Demo with Operate connected via port forward and show version


# Demo 2 - Demo Java Spring project and we will show it set up and how business user can contribute to the project


Premise: I am a developer or represent a development team that need to develop credit card payment.
My task is to set up my environment and start moving to CI/CD. This demo will focus on CI.
