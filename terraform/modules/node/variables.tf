############################################################################################
variable "interface" {
  type    = list(any)
  default = ["ens01", "ens02"]
}

#############################################################################################
variable "vcpu" {
  type = string
}
variable "memories" {
  type = string
}
variable "distros" {
  type = string
}
variable "hostnames" {
  type = string
}

#############################################################################################
variable "interface_1_ips" {
  type = list(any)
}
variable "interface_2_ips" {
  type = list(any)
}

#############################################################################################
variable "interface_1_macs" {
  type = list(any)
}

variable "interface_2_macs" {
  type = list(any)
}

##############################################################################################
variable "user" {
  type    = string
  default = "k8sadmin"
}

variable "public_key_path" {
  description = "Path to ssh public key, which would be used to access workers"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to ssh private key, which would be used to access workers"
  default     = "~/.ssh/id_rsa"
}

variable "apt_cacher_http_proxy_url" {
  type        = string
  description = "URL to apt package caching system, if empty then disabled."
  default     = ""
}

variable "apt_cacher_https_proxy_url" {
  type        = string
  description = "URL to apt package caching system, if empty then disabled."
  default     = ""
}
