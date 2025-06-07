# Deckhouse on KVM

Project for automatic deployment of Deckhouse Kubernetes Platform cluster on KVM virtual machines using Terraform and Ansible.

## Architecture

- **loadbalancer** (192.168.122.21) - HAProxy entry point to the cluster:
  - Port 6445 → Kubernetes API (master1)
  - Port 80/443 → Ingress controller (ingress1)
- **master1** (192.168.122.11) - Deckhouse master node with API server
- **worker1** (192.168.122.41) - Worker node for application pods
- **ingress1** (192.168.122.31) - Ingress node for external traffic

Load balancer serves as a single entry point for:
- Kubernetes API access via kubectl
- HTTP/HTTPS traffic to applications via Ingress

After deployment:
- Kubernetes API is available at: `https://192.168.122.21:6445`
- Web applications are available at: `http://192.168.122.21`

## Project Contents

### Terraform (terraform/)
- Creating 4 Debian 12 virtual machines
- Network configuration (192.168.122.0/24)
- SSH keys and users

### Ansible (ansible/)
- `playbooks/deckhouse.yaml` - main playbook for Deckhouse deployment
- `playbooks/lbs.yaml` - playbook for load balancer configuration
- `playbooks/roles/initial_loading/` - basic node configuration
- `playbooks/roles/setup_containerd/` - container runtime configuration
- `playbooks/roles/setup_docker/` - Docker configuration
- `playbooks/roles/setup_kube/` - Kubernetes configuration
- `playbooks/roles/setup_deckhouse/` - Deckhouse installation and configuration
- `playbooks/roles/setup_lb/` - HAProxy load balancer configuration

## Requirements

- KVM/libvirt
- Terraform >= 1.0
- Ansible >= 2.10
- Python3 with virtualenv
- Minimum 8GB RAM and 4 CPU

## Detailed Installation

1. **Creating VMs:**
   ```bash
   ./0001_load_vm_bootimages.sh
   ./0002_terraform_init.sh
   ./001_vm_provision.sh
   ```

2. **Ansible start:**
   ```bash
   cd ansible
   ./start_playbooks.sh
   ```
## Deployment Features

### Automatic SSH Configuration
The `setup_deckhouse` role automatically:
- Generates SSH keys for the `caps` user
- Creates the `caps` user on all cluster worker nodes
- Configures passwordless SSH access
- Creates SSHCredentials resource in Deckhouse

### StaticInstance for Nodes
Automatically creates StaticInstance resources for:
- Worker nodes with `role: worker` label
- Ingress nodes with `role: ingress` label

### Ingress Configuration
- Ingress nodes receive taint `node-role.kubernetes.io/ingress=:NoSchedule`
- IngressNginxController is configured with HostPort inlet
- Ingress controller is bound to ports 80/443
