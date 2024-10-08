resource "helm_release" "camunda-platform" {
  name       = "camunda"
  repository = "https://helm.camunda.io"
  chart      = "camunda-platform"
  version    = "10.4.1"
  # version    = "11.0.0"
  namespace  = "camunda"

  create_namespace = true

  values = [file("${path.module}/values-v8.5.yaml")]

  # Inline set values based on your original YAML configuration
  set {
    name  = "global.identity.auth.enabled"
    value = "false"
  }

  set {
    name  = "identity.enabled"
    value = "false"
  }

  set {
    name  = "identity.keycloak.enabled"
    value = "false"
  }

  set {
    name  = "zeebe.clusterSize"
    value = "1"
  }

  set {
    name  = "zeebe.replicationFactor"
    value = "1"
  }

  set {
    name  = "zeebe.partitionsCount"
    value = "1"
  }
    
  set {
    name  = "zeebeGateway.replicas"
    value = "1"
  }

  set {
    name  = "connectors.enabled"
    value = "false"
  }

  set {
    name  = "elasticsearch.master.resources.requests.memory"
    value = "1Gi"
  }

  set {
    name  = "elasticsearch.master.resources.requests.cpu"
    value = "0.5"
  }
  timeout = 1200 # Timeout in seconds
  depends_on = [module.eks_cluster]
}