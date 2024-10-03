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
        #   env {
        #     name  = "ZEEBE_GATEWAY_ADDRESS"
        #     value = "camunda-zeebe-gateway.camunda.svc.cluster.local:26500"
        #   }
        }
      }
    }
  }
}

variable "image_tag" {
  description = "The tag of the Docker image to deploy"
  type        = string
  default     = "latest"
}