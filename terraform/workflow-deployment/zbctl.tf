
resource "kubernetes_job" "zeebe_cli" {
  metadata {
    name      = "zeebe-cli-job"
    namespace = "camunda" # Change to your namespace if needed
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
          image = "node:18-alpine"

          command = ["/bin/sh", "-c"]
          args    = [
            "apk update && npm install -g zbctl && zbctl --address camunda-zeebe-gateway.camunda.svc.cluster.local:26500 --insecure ../../Workflow/process_payment.bpmn"
          ]
        }
      }
    }
  }
}