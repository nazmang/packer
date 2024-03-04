packer {
  required_version = ">= 1.10.0"
  required_plugins {
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = ">= 1.2.4"
    }
  }
}

locals {
  kali_iso_url = "https://kali.download/base-images/kali-${var.kali_version}/kali-linux-${var.kali_version}-installer-amd64.iso"
  vm_name      = "kali-linux-${var.kali_version}"
}

source "vsphere-iso" "kali" {
  // vCenter Server Endpoint Settings and Credentials
  vcenter_server      = var.vsphere_endpoint
  username            = var.vsphere_username
  password            = var.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  // vSphere Settings
  datacenter = var.vsphere_datacenter
  cluster    = var.vsphere_cluster
  datastore  = var.vsphere_datastore
  folder     = var.vsphere_folder

  boot_command = [
    "<esc><wait>",
    "install preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg debian-installer=en_US auto locale=en_US kbd-chooser/method=us <wait>",
    "netcfg/get_hostname={{ .Name }} netcfg/get_domain=local fb=false debconf/frontend=noninteractive console-setup/ask_detect=false <wait>",
    "console-keymaps-at/keymap=us keyboard-configuration/xkb-keymap=us <wait>",
    "<enter><wait>"
  ]
  boot_wait = "10s"
  CPUs      = 2
  cpu_cores = 2
  RAM       = 2048
  storage {
    disk_size             = 20480
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.vsphere_network
    network_card = "e1000"
  }

  guest_os_type = "debian10_64Guest"

  http_content = {
    "/preseed.cfg" = templatefile("${abspath(path.root)}/preseed.pkrtpl", {
      root_password = var.root_password,
      kali_user_name = var.kali_user_name,
      kali_user_password = var.kali_user_password,
      kali_user_fullname = var.kali_user_fullname
    })
  }

  iso_checksum = var.kali_iso_checksum
  iso_paths = [
    var.kali_iso_path
  ]
  # iso_url          = local.kali_iso_url 
  shutdown_command = "sudo shutdown -P now"
  ssh_password     = var.root_password
  ssh_port         = 22
  ssh_username     = "root"
  ssh_timeout      = "15m"
  vm_name          = local.vm_name

  convert_to_template = true
}

build {
  sources = ["source.vsphere-iso.kali"]

  provisioner "shell" {
    environment_vars = [
      "ROOT_SSH_KEY=${var.root_ssh_key}",
      "ROOT_PASSWORD=${var.root_password}",
      "KALI_USER=${var.kali_user_name}",
      "KALI_SSH=${var.kali_user_ssh_key}}"
    ]
    # execute_command   = "sudo -S sh '{{ .Path }}'"
    expect_disconnect = true
    scripts = [
      # "scripts/update.sh",
      "scripts/vmtools.sh",
      "scripts/users.sh"
    ]
  }

}
