data "aws_secretsmanager_secret_version" "shahaf-mongo-secrets" {
  secret_id = "mongo-auth-shahaf"
}

resource "kubernetes_secret" "mongo-secrets" {
  metadata {
    name      = "mongo-auth"
    namespace = "app"
  }

  data = {
    "mongodb-passwords"       = jsondecode(data.aws_secretsmanager_secret_version.shahaf-mongo-secrets.secret_string)["mongodb-passwords"]
    "mongodb-root-password"   = jsondecode(data.aws_secretsmanager_secret_version.shahaf-mongo-secrets.secret_string)["mongodb-root-password"]
    "mongodb-replica-set-key" = jsondecode(data.aws_secretsmanager_secret_version.shahaf-mongo-secrets.secret_string)["mongodb-replica-set-key"]
  }

  type       = "Opaque"
  depends_on = [kubernetes_namespace.app]
}
