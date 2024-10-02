# camunda-rapid-deployment
Demo for Camunda Con New York 2024

Terraform configuration and deployment

## Let me introduce my set up and assumption

For simplicity I am running something very simple: Of cource we will have actiosn for each pull request to veryfy code formatiign, Unit Tests, etc etc

I took Camunda AWS EKS guide and created Terraform actions 'terraform.yaml' the only change I made is to save state in S3.
I also create IAM user and with OIDC granted access to GitHub Actions execution 

/terraform/camunda-deployment is folder where my Terraform script to deploy EKS cluster and Deploy Camunda.
/teraform/workflow-deployment is fodler where I deloy my Workflow project every time I get PR create and it needs to run through my integraton tests or even deploy to production. You can see a set of Action based on this example that run Unit Tests, integrations tests and if pass deploy this workflow to production.

Add IAM access Entry
aws eks create-access-entry --cluster-name my-cluster --principal-arn arn:aws:iam::111122223333:role/my-role --type STANDARD --user Viewers --kubernetes-groups Viewers


Create new EKS context `aws eks --region eu-west-1 update-kubeconfig --name cluster-name`