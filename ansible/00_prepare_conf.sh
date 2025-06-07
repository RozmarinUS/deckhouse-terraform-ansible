#!/bin/bash

THIS=$(readlink -f "${BASH_SOURCE[0]}")
DIR=$(dirname "${THIS}")

pushd $DIR

VENVDIR=venv
virtualenv --python=/usr/bin/python3 $VENVDIR >/dev/null 2>&1

source $VENVDIR/bin/activate
source ../terraform_output.sh

cat >hosts <<EOF

[k8s_lbs]
$ip_address_lb_1 ansible_become_user=root

[k8s_nodes]
$ip_address_kube_master_1 ansible_become_user=root
$ip_address_kube_worker_1 ansible_become_user=root
$ip_address_kube_ingress_1 ansible_become_user=root

[k8s_masters]
$ip_address_kube_master_1 ansible_become_user=root

[k8s_workers]
$ip_address_kube_worker_1 ansible_become_user=root

[k8s_ingresses]
$ip_address_kube_ingress_1 ansible_become_user=root
EOF

cat >playbooks/tmp/remote_hosts <<EOF
$ip_address_lb_1            lb1.example.com          lb1
$ip_address_kube_master_1   kube_master1.example.com     kube_master1
$ip_address_kube_worker_1   kube_worker1.example.com     kube_worker1
$ip_address_kube_ingress_1  kube-ingress1.example.com     ingress1
EOF

pip install --disable-pip-version-check -q -r requirements.txt

popd
