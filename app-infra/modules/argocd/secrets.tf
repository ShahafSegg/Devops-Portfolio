data "aws_secretsmanager_secret_version" "shahaf-pf-secrets" {
  secret_id = "shahaf-pf-secrets"
}
