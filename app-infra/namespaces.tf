
resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }
}

resource "kubernetes_namespace" "efk" {
  metadata {
    name = "efk"
  }
}
