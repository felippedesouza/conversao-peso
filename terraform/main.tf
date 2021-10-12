#qual provider o terraform vai usar
terraform {
  required_providers {
    digitalocean = {
      source   = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

#variavel para o token nao ficar exposto num arquivo compartilhavel
variable "DIGITAL_OCEAN_TOKEN" {}
variable "NOME_K8S" {}

#declaracao do provider
provider "digitalocean" {
  token = var.DIGITAL_OCEAN_TOKEN
}

#declarar a infraestrutura, criar um recurso no servico
resource "digitalocean_kubernetes_cluster" "k8s" {
  name = var.NOME_K8S
  region = "nyc1"
  version = "1.21.3-do.0"

  node_pool {
    name = "default-pool"
    size = "s-2vcpu-2gb"
    node_count = 1
  }
}

#coloca um arquivo na maquina local
resource "local_file" "k8s_config" {
  content = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "kube_config"
}