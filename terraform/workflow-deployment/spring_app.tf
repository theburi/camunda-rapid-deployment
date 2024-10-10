resource "kubernetes_deployment" "spring_app" {
  metadata {
    name      = "spring-app"
    namespace = "camunda"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "spring-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "spring-app"
        }
      }

      spec {
        container {
          name  = "spring-app"
          image = "theburi/my-getting-started:${var.image_tag}"  # The image tag from the GitHub Actions workflow

          port {
            container_port = 8080
          }

          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = "prod"
          }
                    # Inject Kubernetes service name as environment variable
          env {
            name  = "ZEEBE_ADDRESS"
            value = "camunda-zeebe-gateway.camunda.svc.cluster.local:26500"
          }
                    env {
            name  = "ZEEBE_CLIENT_ID"
            value = "zeebe"
          }

          env {
            name  = "ZEEBE_AUTHORIZATION_SERVER_URL"
            value = "http://camunda-keycloak.camunda.svc.cluster.local/auth/realms/camunda-platform/protocol/openid-connect/token"
          }

          env {
            name  = "ZEEBE_TOKEN_AUDIENCE"
            value = "zeebe-api"
          }
          # Reference the secret for sensitive value
          env {
            name = "ZEEBE_CLIENT_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.zeebe_auth.metadata[0].name
                key  = "ZEEBE_CLIENT_SECRET"
              }
            }
          }
        }
      }
    }
  }
  depends_on = [ kubernetes_secret.zeebe_auth ]
}

variable "image_tag" {
  description = "The tag of the Docker image to deploy"
  type        = string
  default     = "latest"
}

resource "kubernetes_secret" "zeebe_auth" {
  metadata {
    name      = "zeebe-auth"
    namespace = "camunda"
  }

  data = {
    ZEEBE_CLIENT_SECRET = "VmVyeUxvbmdTdHJpbmc="  # Base64 encoded value
  }

  type = "Opaque"
}