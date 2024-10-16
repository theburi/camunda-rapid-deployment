# Create the Camunda namespace
resource "kubernetes_namespace" "camunda_namespace" {
  metadata {
    name = "camunda"
  }
  depends_on = [ module.eks_cluster ]
}

resource "helm_release" "camunda-platform" {
  name       = "camunda"
  repository = "https://helm.camunda.io"
  chart      = "camunda-platform"
  # version    = "10.4.1"
  version    = "11.0.0"
  namespace  = "camunda"

  create_namespace = true

  values = [file("${path.module}/values-v8.6.yaml")]

  # Inline set values based on your original YAML configuration

  set {
    name  = "optimize.enabled"
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

  # Global identity.auth configuration with existing secrets
  set {
    name  = "global.identity.auth.operate.existingSecret.name"
    value = "identity-secret-for-components"
  }

  set {
    name  = "global.identity.auth.tasklist.existingSecret.name"
    value = "identity-secret-for-components"
  }

  set {
    name  = "global.identity.auth.optimize.existingSecret.name"
    value = "identity-secret-for-components"
  }

  set {
    name  = "global.identity.auth.webModeler.existingSecret.name"
    value = "identity-secret-for-components"
  }

  set {
    name  = "global.identity.auth.connectors.existingSecret.name"
    value = "identity-secret-for-components"
  }

  set {
    name  = "global.identity.auth.console.existingSecret.name"
    value = "identity-secret-for-components"
  }

  set {
    name  = "global.identity.auth.zeebe.existingSecret.name"
    value = "identity-secret-for-components"
  }
  
  # Set Keycloak configurations (update these values as needed)
  set {
    name  = "identity.keycloak.url"
    value = "http://camunda-platform-keycloak.camunda.svc.cluster.local/auth"
  }

  set {
    name  = "identity.keycloak.clientID"
    value = "camunda-identity"
  }

  set {
    name  = "identity.keycloak.realm"
    value = "camunda"
  }

  timeout = 600 # Timeout in seconds  
  depends_on = [
    kubernetes_secret.identity_secret_for_components,
    module.eks_cluster
  ]
}

resource "kubernetes_secret" "identity_secret_for_components" {
  metadata {
    name      = "identity-secret-for-components"
    namespace = "camunda"
  }

  data = {
    operate-secret     = "VmVyeUxvbmdTdHJpbmc="
    tasklist-secret    = "VmVyeUxvbmdTdHJpbmc="
    optimize-secret    = "VmVyeUxvbmdTdHJpbmc="
    connectors-secret  = "VmVyeUxvbmdTdHJpbmc="
    console-secret     = "VmVyeUxvbmdTdHJpbmc="
    keycloak-secret    = "VmVyeUxvbmdTdHJpbmc="
    zeebe-secret       = "VmVyeUxvbmdTdHJpbmc="
  }

  type = "Opaque"
  depends_on = [
    kubernetes_namespace.camunda_namespace,
    module.eks_cluster
  ]
}