data "aws_secretsmanager_secret_version" "argocd_ssh_key" {
  secret_id = "shahaf-ssh-key"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_secret" "argocd_repo_creds" {
  metadata {
    name      = "argocd-repo-creds"
    namespace = "argocd"

    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    name          = "gitops-repo"
    type          = "git"
    project       = "*"
    url           = "git@gitlab.com:shahaf4/gitops-app.git"
    sshPrivateKey = data.aws_secretsmanager_secret_version.argocd_ssh_key.secret_string
  }

  depends_on = [helm_release.argocd]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.0.0"

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt((jsondecode(data.aws_secretsmanager_secret_version.shahaf-pf-secrets.secret_string)["argocd-pass"]))
  }

  depends_on = [kubernetes_namespace.argocd]
}



resource "kubectl_manifest" "argocd_application" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-apps
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "git@gitlab.com:shahaf4/gitops-app.git"
    targetRevision: HEAD
    path: apps
  destination:
    server: "https://kubernetes.default.svc"
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true
YAML

  depends_on = [helm_release.argocd]
}
