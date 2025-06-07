##############################################################3
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "worker" {
  source = "./modules/node"

  hostnames        = "kube-worker"
  distros          = "debian12"
  vcpu             = "4"
  memories         = "8192"
  interface_1_ips  = ["192.168.122.41"]
  interface_2_ips  = ["10.251.13.218"]
  interface_1_macs = ["52:54:00:9d:94:08"]
  interface_2_macs = ["52:54:00:9d:94:18"]
}

module "master" {
  source = "./modules/node"

  hostnames        = "kube-master"
  distros          = "debian12"
  vcpu             = "4"
  memories         = "8192"
  interface_1_ips  = ["192.168.122.11"]
  interface_2_ips  = ["10.251.13.213"]
  interface_1_macs = ["52:54:00:50:99:03"]
  interface_2_macs = ["52:54:00:50:99:13"]
}

module "loadbalancer" {
  source = "./modules/node"

  hostnames        = "loadbalancer"
  distros          = "debian12"
  vcpu             = "2"
  memories         = "1024"
  interface_1_ips  = ["192.168.122.21"]
  interface_2_ips  = ["10.251.13.211"]
  interface_1_macs = ["52:54:02:50:99:01"]
  interface_2_macs = ["52:54:02:50:99:11"]
}

module "ingress" {
  source = "./modules/node"

  hostnames        = "kube-ingress"
  distros          = "debian12"
  vcpu             = "2"
  memories         = "4096"
  interface_1_ips  = ["192.168.122.31"]
  interface_2_ips  = ["10.251.13.216"]
  interface_1_macs = ["52:54:00:9d:94:06"]
  interface_2_macs = ["52:54:00:9d:94:16"]
}
