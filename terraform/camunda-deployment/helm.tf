resource "helm_release" "camunda-platform" {
  name       = "camunda"
  repository = "https://helm.camunda.io"
  chart      = "camunda-platform"
  version    = "10.3.2"
  namespace  = "camunda"

  create_namespace = true

  values = [
    <<EOF
    global:
        identity:
            auth:
                enabled: false
    
    # Disable Identity for local development
    identity:
        enabled: false
        keycloak:
            enabled: false
    zeebe:
      replicas: 1
      gateway:
        replicas: 1

    connectors:
        enabled: false

    elasticsearch:
      master:
        resources:
          requests:
            memory: 1Gi
        
    EOF
  ]


  depends_on = [module.eks_cluster]
}