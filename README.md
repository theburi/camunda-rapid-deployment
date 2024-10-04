# camunda-rapid-deployment
Demo for CamundaCon New York 2024

Terraform configuration and deployment
Premise: I am a developer or represent a development team that need to develop credit card payment.
My task is to set up my environment and start moving to CI/CD. This demo will focus on CI.


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

For simplicity we do not show a full test suit.

Add IAM access Entry
aws eks create-access-entry --cluster-name demo-cluster-name --principal-arn AWSReservedSSO_SystemAdministrator_3272c85503826b83/andrey.belik@camunda.com --type STANDARD 


Create new EKS context `aws eks --region eu-west-1 update-kubeconfig --name demo-cluster-name`


### Demo on the environment:
We have deployed EKS and Helm 8.4 and now we would like to update to 8.5
lets review files and switch to our provided 8.5 values, check in and submit.
