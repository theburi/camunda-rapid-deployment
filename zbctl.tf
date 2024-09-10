
resource "kubernetes_job" "zeebe_cli" {
  metadata {
    name      = "zeebe-cli-job"
    namespace = "default" # Change to your namespace if needed
  }

  spec {
    template {
      metadata {
        labels = {
          app = "zeebe-cli"
        }
      }

      spec {
        restart_policy = "OnFailure"

        container {
          name  = "zeebe-cli"
          image = "alpine:3.17"
          command = ["/bin/sh", "-c", <<EOF
            apk add --no-cache curl bash \
            && curl -L https://github.com/camunda/zeebe/releases/download/8.2.5/zbctl-8.2.5-linux-amd64.tar.gz \
            | tar -xz -C /usr/local/bin \
            && zbctl --address zeebe-gateway.camunda.svc.cluster.local:26500 status
            EOF
          ]
        }
      }
    }
  }
}