# Generate inventory file
resource "local_file" "ansible_inventory" {
  filename = "/home/andreasm/terraform/proxmox/kubespray/inventory/k8s-cluster-02/inventory.ini"
  content = <<-EOF
  [all]
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[0].name} ansible_host=${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[0].ipv4_addresses[1][0]}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[1].name} ansible_host=${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[1].ipv4_addresses[1][0]}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[2].name} ansible_host=${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[2].ipv4_addresses[1][0]}
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[0].name} ansible_host=${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[0].ipv4_addresses[1][0]}
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[1].name} ansible_host=${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[1].ipv4_addresses[1][0]}
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[2].name} ansible_host=${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[2].ipv4_addresses[1][0]}

  [kube_control_plane]
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[0].name}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[1].name}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[2].name}

  [etcd]
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[0].name}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[1].name}
  ${proxmox_virtual_environment_vm.k8s-cp-vms-cl02[2].name}

  [kube_node]
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[0].name}
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[1].name}
  ${proxmox_virtual_environment_vm.k8s-worker-vms-cl02[2].name}

  [k8s_cluster:children]
  kube_node
  kube_control_plane

  EOF
}

resource "null_resource" "ansible_command" {
  provisioner "local-exec" {
    command = "./kubespray.k8s-cluster-02.sh > k8s-cluster-02/ansible_output.log 2>&1"
    interpreter = ["/bin/bash", "-c"]
    working_dir = "/home/andreasm/terraform/proxmox"
    }
  depends_on = [proxmox_virtual_environment_vm.k8s-cp-vms-cl02, proxmox_virtual_environment_vm.k8s-worker-vms-cl02, local_file.ansible_inventory]
  }

