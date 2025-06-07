terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

resource "libvirt_volume" "distro-qcow2" {
  count  = length(var.interface_1_ips)
  name   = "${var.hostnames}${count.index+1}.qcow2"
  pool   = "default"
  source = "${abspath(path.module)}/sources/${var.distros}.qcow2"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" { 
  count     = length(var.interface_1_ips)
  name      = "commoninit-${var.hostnames}${count.index+1}.iso"
  pool      = "default"  
  user_data = templatefile("${path.module}/templates/user_data.tpl", {
      host_name = "${var.hostnames}${count.index+1}"
      auth_key  = file(var.public_key_path)
      user      = var.user
      apt_cacher_https_proxy_url = var.apt_cacher_https_proxy_url
      apt_cacher_http_proxy_url = var.apt_cacher_http_proxy_url     
  })
  network_config =   templatefile("${path.module}/templates/network_config.tpl", {
     interface_1 = var.interface[0]
     interface_2 = var.interface[1]
     ip_addr_1   = var.interface_1_ips[count.index]
     ip_addr_2   = var.interface_2_ips[count.index]
     mac_addr_1  = var.interface_1_macs[count.index]
     mac_addr_2  = var.interface_2_macs[count.index]     
  })
}

resource "libvirt_domain" "domain-distro" {
  count  = length(var.interface_1_ips)
  name   = "${var.hostnames}${count.index+1}"
  memory = var.memories
  vcpu   = var.vcpu
  cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)

  autostart = "false"
  qemu_agent = "false"

  network_interface {
      network_name = "default"
      addresses    = [var.interface_1_ips[count.index]]
      mac = var.interface_1_macs[count.index]
  }

    network_interface {
      network_name = "default"
      addresses    = [var.interface_2_ips[count.index]]
      mac = var.interface_2_macs[count.index]
  }

  console {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
  }
  console {
      type        = "pty"
      target_port = "1"
      target_type = "virtio"
  }
  disk {
      volume_id = element(libvirt_volume.distro-qcow2.*.id, count.index)
  }
}
