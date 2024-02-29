# Copyright 2023-2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2

/*
    DESCRIPTION:
    Microsoft Windows Server 2019 build definition.
    Packer Plugin for VMware vSphere: 'vsphere-iso' builder.
*/

//  BLOCK: packer
//  The Packer configuration.

packer {
  required_version = ">= 1.10.0"
  required_plugins {
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = ">= 1.2.4"
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

//  BLOCK: data
//  Defines the data sources.

# data "git-repository" "cwd" {}

//  BLOCK: locals
//  Defines the local variables.

locals {
  build_by                   = "Built by: ${var.vsphere_username} HashiCorp Packer ${packer.version}"
  build_date                 = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
#   build_version              = data.git-repository.cwd.head
  build_version              = "1.0.1"
  build_description          = "Version: ${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}"
  vm_name_datacenter_core    = "tpl-${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_datacenter}-${var.vm_guest_os_experience_core}-${local.build_version}"
  vm_name_datacenter_desktop = "tpl-${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_datacenter}-${var.vm_guest_os_experience_desktop}-${local.build_version}"
  vm_name_standard_core      = "tpl-${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_standard}-${var.vm_guest_os_experience_core}-${local.build_version}"
  vm_name_standard_desktop   = "tpl-${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_guest_os_edition_standard}-${var.vm_guest_os_experience_desktop}-${local.build_version}"
  iso_paths                  = ["[${var.common_iso_datastore}] ${var.iso_path}/${var.iso_file}", "[] /vmimages/tools-isoimages/${var.vm_guest_os_family}.iso"]
  manifest_date              = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path              = "${path.cwd}/output/"
  manifest_output            = "${local.manifest_path}${local.manifest_date}.tfvars.json"
  bucket_name                = replace("${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}", ".", "")
  bucket_description         = "${var.vm_guest_os_family} ${var.vm_guest_os_name} ${var.vm_guest_os_version}"
}