resource "proxmox_virtual_environment_vm" "k8s-cp-vms-cl02" {
  count       = 3
  name        = "k8s-cp-vm-${count.index + 1}-cl-02"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu", "k8s-cp"]

  node_name = "proxmox-02"
  vm_id     = "100${count.index + 1}"


  cpu {
    cores = 2
    type = "host"
  }

  memory {
    dedicated = 2048
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
        address = "10.160.1.2${count.index + 1}/24"
        gateway = "10.160.1.1"
      }
    }
    datastore_id = "raid-10-node02"

    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = "216"
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


}

resource "proxmox_virtual_environment_vm" "k8s-worker-vms-cl02" {
  count       = 3
  name        = "k8s-node-vm-${count.index + 1}-cl-02"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu", "k8s-node"]

  node_name = "proxmox-02"
  vm_id     = "100${count.index + 5}"


  cpu {
    cores = 4
    type = "host"
  }

  memory {
    dedicated = 4096
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
        address = "10.160.1.2${count.index + 5}/24"
        gateway = "10.160.1.1"
      }
    }
    datastore_id = "raid-10-node02"

    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = "216"
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


}

