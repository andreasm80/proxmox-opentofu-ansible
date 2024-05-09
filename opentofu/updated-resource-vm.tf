resource "proxmox_virtual_environment_vm" "rke2-cp-vms-cl01" {
  count       = 3
  name        = "rke2-cp-vm-${count.index + 1}-cl-01"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu", "k8s-cp"]

  timeout_clone = 180
  timeout_create = 180
  timeout_migrate = 180
  timeout_reboot = 180
  timeout_shutdown_vm = 180
  timeout_start_vm = 180
  timeout_stop_vm = 180

  node_name = "proxmox-02"
  vm_id     = "102${count.index + 1}"

  cpu {
    cores = 4
    type = "host"
  }

  memory {
    dedicated = 6144
  }


  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  disk {
    datastore_id = "raid-10-node02"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 40
    file_format  = "raw"
  }


  initialization {
    dns {
      servers = ["10.100.1.7", "10.100.1.6"]
      domain = "my-domain.net"
    }
    ip_config {
      ipv4 {
        address = "10.170.0.1${count.index + 1}/24"
        gateway = "10.170.0.1"
      }
    }
    datastore_id = "raid-10-node02"

    user_data_file_id = proxmox_virtual_environment_file.rke2-cp-vms-cl01[count.index].id
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = "217"
  }

  operating_system {
    type = "l26"
  }

  keyboard_layout = "no"



  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }
  depends_on = [proxmox_virtual_environment_file.rke2-cp-vms-cl01]

}

resource "proxmox_virtual_environment_vm" "rke2-worker-vms-cl01" {
  count       = 3
  name        = "rke2-node-vm-${count.index + 1}-cl-01"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu", "k8s-node"]

  node_name = "proxmox-02"
  vm_id     = "102${count.index + 5}"


  timeout_clone = 180
  timeout_create = 180
  timeout_migrate = 180
  timeout_reboot = 180
  timeout_shutdown_vm = 180
  timeout_start_vm = 180
  timeout_stop_vm = 180

  cpu {
    cores = 4
    type = "host"
  }

  memory {
    dedicated = 6144
  }


  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  disk {
    datastore_id = "raid-10-node02"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 60
    file_format  = "raw"
  }


  initialization {
    dns {
      servers = ["10.100.1.7", "10.100.1.6"]
      domain = "my-domain.net"
    }
    ip_config {
      ipv4 {
        address = "10.170.0.1${count.index + 5}/24"
        gateway = "10.170.0.1"
      }
    }
    datastore_id = "raid-10-node02"

    user_data_file_id = proxmox_virtual_environment_file.rke2-worker-vms-cl01[count.index].id
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = "217"
  }

  operating_system {
    type = "l26"
  }

  keyboard_layout = "no"


  lifecycle {
    ignore_changes = [
      network_device,
    ]
  }

  depends_on = [proxmox_virtual_environment_file.rke2-worker-vms-cl01]

}

resource "null_resource" "rke2-cp-vms-cl01" {
  count = 3

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname rke2-cp-vm-${count.index + 1}-cl-01.my-domain.net"]
    connection {
      type        = "ssh"
      user        = "ubuntu"  # or another user
      private_key = file("${var.private_key_path}")
      host        = element([for ip in flatten(proxmox_virtual_environment_vm.rke2-cp-vms-cl01[count.index].ipv4_addresses) : ip if ip != "127.0.0.1"], 0)
    }
  }
  depends_on = [proxmox_virtual_environment_vm.rke2-cp-vms-cl01]
}

resource "null_resource" "rke2-worker-vms-cl01" {
  count = 3

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname rke2-node-vm-${count.index + 1}-cl-01.my-domain.net"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.private_key_path}")
      host = element([for ip in flatten(proxmox_virtual_environment_vm.rke2-worker-vms-cl01[count.index].ipv4_addresses) : ip if ip != "127.0.0.1"], 0)

    }
  }
  depends_on = [proxmox_virtual_environment_vm.rke2-worker-vms-cl01]
}

output "usable_cp_vm_ipv4_addresses" {
  value = [for ip in flatten(proxmox_virtual_environment_vm.rke2-cp-vms-cl01[*].ipv4_addresses) : ip if ip != "127.0.0.1"]
}

output "usable_worker_vm_ipv4_addresses" {
  value = [for ip in flatten(proxmox_virtual_environment_vm.rke2-worker-vms-cl01[*].ipv4_addresses) : ip if ip != "127.0.0.1"]
}

