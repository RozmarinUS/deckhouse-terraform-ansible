#!/bin/bash

set -e

THIS=$(readlink -f "${BASH_SOURCE[0]}")
DIR=$(dirname "${THIS}")

pushd $DIR

echo '######################################################################### create_hosts'
source ./00_prepare_conf.sh

echo "Setting up virtual environment..."
VENVDIR=venv
virtualenv --python=/usr/bin/python3 $VENVDIR >/dev/null 2>&1

source $VENVDIR/bin/activate
source ../terraform_output.sh

echo "Installing Ansible dependencies..."
pip install -r requirements.txt

USER=$admin_username

echo "Copying Terraform configuration..."
cp ../terraform_output.sh ./playbooks/tmp

echo "Copying SSH key to master node..."
scp ~/.ssh/id_rsa $USER@$ip_address_kube_master_1:/home/$USER/.ssh/id_rsa
scp ~/.ssh/id_rsa.pub $USER@$ip_address_kube_master_1:/home/$USER/.ssh/id_rsa.pub
ssh $USER@$ip_address_kube_master_1 "chmod 600 /home/$USER/.ssh/id_rsa && chmod 644 /home/$USER/.ssh/id_rsa.pub && sudo cp /home/$USER/.ssh/id_rsa /root/.ssh/id_rsa && sudo cp /home/$USER/.ssh/id_rsa.pub /root/.ssh/id_rsa.pub && sudo chmod 600 /root/.ssh/id_rsa && sudo chmod 644 /root/.ssh/id_rsa.pub"

echo '######################################################################### setup_lb'
ansible-playbook -i hosts -b -u $USER playbooks/lbs.yaml

echo '######################################################################### setup_deckhouse'
ansible-playbook -i hosts -b -u $USER playbooks/deckhouse.yaml

echo "Configuring /etc/hosts for service access..."
if ! grep -q "api-svc.globalart.local" /etc/hosts; then
    sudo -E bash -c "cat <<EOF >> /etc/hosts
$k8s_ingress_endpoint api-svc.globalart.local
$k8s_ingress_endpoint argocd-svc.globalart.local
$k8s_ingress_endpoint dashboard-svc.globalart.local
$k8s_ingress_endpoint documentation-svc.globalart.local
$k8s_ingress_endpoint console-svc.globalart.local
$k8s_ingress_endpoint dex-svc.globalart.local
$k8s_ingress_endpoint grafana-svc.globalart.local
$k8s_ingress_endpoint hubble-svc.globalart.local
$k8s_ingress_endpoint istio-svc.globalart.local
$k8s_ingress_endpoint istio-api-proxy-svc.globalart.local
$k8s_ingress_endpoint kubeconfig-svc.globalart.local
$k8s_ingress_endpoint openvpn-admin-svc.globalart.local
$k8s_ingress_endpoint prometheus-svc.globalart.local
$k8s_ingress_endpoint status-svc.globalart.local
$k8s_ingress_endpoint upmeter-svc.globalart.local
EOF
"
fi
popd
