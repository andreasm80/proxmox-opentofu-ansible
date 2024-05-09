# CP VMs
resource "proxmox_virtual_environment_file" "rke2-cp-vms-cl01" {
  count = 3 # adjust pr total amount of VMs
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "proxmox-02"

  source_raw {
    data = <<EOF
#cloud-config
chpasswd:
  list: |
    ubuntu:ubuntu    
  expire: false
packages:
  - qemu-guest-agent
timezone: Europe/Oslo

users:
  - default
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - ${trimspace("ssh-rsa E8lMzi2QtaV6FbEGQG41sKUetP4IfQ9OKQb4n3pIleyuFySijxWS37krexsd9E2rkJFjz0rhh1idWb4vfzQH15lsBIaA1JpcYTqJWp6QwJ8oV2psQUi/knwVNfn3EckKrkNsGwUw6+d")}
    sudo: ALL=(ALL) NOPASSWD:ALL

power_state:
    delay: now
    mode: reboot
    message: Rebooting after cloud-init completion
    condition: true

EOF

    file_name = "rke2-cp-vms-${count.index + 1}-cl01.yaml"
  }
}

# Node VMs
resource "proxmox_virtual_environment_file" "rke2-worker-vms-cl01" {
  count = 3 # adjust pr total amount of VMs
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "proxmox-02"

  source_raw {
    data = <<EOF
#cloud-config
chpasswd:
  list: |
    ubuntu:ubuntu    
  expire: false
packages:
  - qemu-guest-agent
timezone: Europe/Oslo

users:
  - default
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - ${trimspace("ssh-rsa AAAAB3NxTSy6hioyUwiRpVUKYDf9zsU4P87zIqasRHMPfoj2PI0YCPihDpQj/e0VtkQaBhyfLoFuLa+zTEDjR5nYt1P0MRWPRuOxY/ls04VCpVvA9mUSYF8ftAXf2SXRY7sqQE3dg4Bav7FdHe1labQH4logd1N5ra9PS+bVGcBDstSH/t7Zkf/Na1EMqN75M5PKiFzHpde7xFnvaRbcVdzr64xTXP2vVj+jTlcMBRAoJQHIO4703jy3Ma2fJbYxipSsl1TGDgUFxf3rDjW/gKOWQhbCVheDMGC94")}
    sudo: ALL=(ALL) NOPASSWD:ALL

power_state:
    delay: now
    mode: reboot
    message: Rebooting after cloud-init completion
    condition: true

EOF

    file_name = "rke2-worker-vms-${count.index + 1}-cl01.yaml"
  }
}

