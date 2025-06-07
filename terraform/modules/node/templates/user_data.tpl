#cloud-config
# vim: syntax=yaml
hostname: ${host_name}
manage_etc_hosts: true
users:
  - name: "${user}"
    groups: wheel
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${auth_key}
ssh_pwauth: true
disable_root: false
growpart:
  mode: auto
  devices: ['/']

package_update: false
packages:
  - qemu-guest-agent

runcmd:
  - systemctl disable systemd-networkd-wait-online.service
  - systemctl mask systemd-networkd-wait-online.service
  - systemctl enable --now qemu-guest-agent

apt:
%{ if apt_cacher_https_proxy_url != "" }
  https_proxy: "${apt_cacher_https_proxy_url}"
%{ endif }
%{ if apt_cacher_http_proxy_url != "" }
  http_proxy: "${apt_cacher_http_proxy_url}"
%{ endif }
