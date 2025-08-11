resource "proxmox_vm_qemu" "cloned-debian" {
  name = "cloned-debian"
  target_node = "pve"
  clone = "debian12-cloudinit"
  full_clone = true
  os_type = "cloud-init"
  boot = "order=virtio0"
  cores = 2
  memory = 2048
  disk {
    storage = "local-lvm"
    type = "virtio"
    size = 20
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
    firewall = false
  }
  ciuser = "root"
}