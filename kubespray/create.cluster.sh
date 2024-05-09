#!/bin/bash

# Set working directory
WORKING_DIR="/home/andreasm/terraform/proxmox"
cd "$WORKING_DIR" || exit

# Set virtual environment variables
VENVDIR="kubespray-venv"
KUBESPRAYDIR="kubespray"

# Activate virtual environment
source "$VENVDIR/bin/activate" || exit

# Change to Kubespray directory
cd "$KUBESPRAYDIR" || exit

# Run Ansible playbook
ansible-playbook -i inventory/k8s-cluster-02/inventory.ini --become --become-user=root cluster.yml -u ubuntu

