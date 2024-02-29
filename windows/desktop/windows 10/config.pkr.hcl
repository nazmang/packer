packer {
  required_plugins {
    vsphere = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/vsphere"
    }
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
    }    
    git = {
      source  = "github.com/ethanmdavidson/git"
      version = ">= 0.6.1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.0"
    }
  }
}

locals {
  build_by           = "Built by: ${var.vsphere_user} HashiCorp Packer ${packer.version}"
  build_date         = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version      = "1.0.2"
  # build_version      = data.git-repository.cwd.head
  build_description  = "Version: ${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"
}