source "vsphere-iso" "win10" {

  // vCenter Server Endpoint Settings and Credentials
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = var.vsphere_insecure_connection


  // vSphere Settings
  datacenter = var.vsphere_datacenter
  cluster    = var.vsphere_compute_cluster
  datastore  = var.vsphere_datastore
  folder     = var.vsphere_folder

  // Virtual Machine Settings
  CPUs          = var.vm_cpu_count
  RAM           = var.vm_mem_size
  firmware      = var.vm_firmware
  guest_os_type = var.vm_guest_os_type
  vm_name       = var.vm_name
  vm_version    = var.common_vm_version
  notes         = local.build_description

  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin_provisioned
  }

  network_adapters {
    network      = var.vsphere_portgroup_name
    network_card = var.vm_network_card
  }

  // Removable Media Settings
  floppy_files = var.config_files
  floppy_content ={
    "sysprep.xml" = templatefile("${abspath(path.root)}/config/sysprep.pkrtpl.hcl", {
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
    })
  }
  iso_paths    = [var.os_iso_path, var.vmtools_iso_path]
  cd_files = [
    "${path.cwd}/scripts/"
  ]
  cd_content = {
    "autounattend.xml" = templatefile("${abspath(path.root)}/config/autounattend.pkrtpl.hcl", {
      build_username           = var.build_username
      build_password           = var.build_password
      vm_inst_os_language      = var.vm_inst_os_language
      vm_inst_os_keyboard      = var.vm_inst_os_keyboard
      vm_inst_os_image         = var.vm_inst_os_image
      vm_inst_os_kms_key       = var.vm_inst_os_kms_key
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
      vm_guest_os_ipv4_address = var.vm_guest_os_ipv4_address
      vm_guest_os_ipv4_prefix  = var.vm_guest_os_ipv4_prefix
      vm_guest_os_ipv4_route   = var.vm_guest_os_ipv4_route
      vm_guest_os_ipv4_dns1    = var.vm_guest_os_ipv4_dns1
      vm_guest_os_ipv4_dns2    = var.vm_guest_os_ipv4_dns2
    })    
  }

  // Boot and Provisioning Settings
  boot_command     = var.vm_boot_command
  boot_order       = var.vm_boot_order
  boot_wait        = var.vm_boot_wait
  shutdown_command = var.vm_shutdown_command

  // Communicator Settings and Credentials
  communicator   = "winrm"
  winrm_username = var.build_username
  winrm_password = var.build_password
  winrm_timeout  = var.winrm_timeout

  // Template and Content Library Settings
  convert_to_template = var.common_template_conversion
  content_library_destination {
    library     = var.common_content_library_name
    description = local.build_description
    ovf         = var.common_content_library_ovf
    destroy     = var.common_content_library_destroy
    skip_import = var.common_content_library_skip_export
  }

}

build {
  name = "win10-consumer-en_us-22H2-feb_2024"
  sources = [
    "source.vsphere-iso.win10"
  ]

  provisioner "powershell" {
    elevated_user     = var.build_username
    elevated_password = var.build_password
    scripts           = var.script_files
  }

  # provisioner "ansible" {
  #   user                   = var.build_username
  #   galaxy_file            = "${path.cwd}/ansible/windows-requirements.yml"
  #   galaxy_force_with_deps = true
  #   use_proxy              = false
  #   playbook_file          = "${path.cwd}/ansible/windows-playbook.yml"
  #   roles_path             = "${path.cwd}/ansible/roles"
  #   ansible_env_vars = [
  #     "ANSIBLE_CONFIG=${path.cwd}/ansible/ansible.cfg"
  #   ]
  #   extra_arguments = [
  #     "--extra-vars", "use_proxy=false",
  #     "--extra-vars", "ansible_connection=winrm",
  #     "--extra-vars", "ansible_user='${var.build_username}'",
  #     "--extra-vars", "ansible_password='${var.build_password}'",
  #     "--extra-vars", "ansible_port='${var.communicator_port}'",
  #     "--extra-vars", "build_username='${var.build_username}'",
  #   ]
  # }

  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true"
    ]
    update_limit = 25
  }

  post-processor "manifest" {
    output     = "output/manifest.auto.tfvars.json"
    strip_path = false
    custom_data = {
      build_username           = var.build_username
      build_password           = var.build_password
      build_date               = local.build_date
      build_version            = local.build_version
      common_vm_version        = var.common_vm_version      
      vm_cpu_count             = var.vm_cpu_count
      vm_disk_size             = var.vm_disk_size
      vm_disk_thin_provisioned = var.vm_disk_thin_provisioned
      vm_firmware              = var.vm_firmware
      vm_guest_os_type         = var.vm_guest_os_type
      vm_mem_size              = var.vm_mem_size
      vm_network_card          = var.vm_network_card
      vsphere_cluster          = var.vsphere_compute_cluster      
      vsphere_datacenter       = var.vsphere_datacenter
      vsphere_datastore        = var.vsphere_datastore      
      vsphere_folder           = var.vsphere_folder
    }
  }
}