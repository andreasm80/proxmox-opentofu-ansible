resource "proxmox_virtual_environment_file" "ubuntu_cloud_init" {
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
      - ${trimspace("ssh-rsa <sha356> user@mail.com")}
    sudo: ALL=(ALL) NOPASSWD:ALL

power_state:
    delay: now
    mode: reboot
    message: Rebooting after cloud-init completion
    condition: true

EOF

    file_name = "ubuntu.cloud-config.yaml"
  }
}

