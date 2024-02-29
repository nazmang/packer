// VCenter settings
variable "vsphere_server" {
  type        = string
  default     = "vcenter.local"
  description = "vCenter Server you are deploying your template to"
}

variable "vsphere_user" {
  type        = string
  default     = "administrator@vsphere.local"
  sensitive   = true
  description = "User with permissions to create VM's and import to the content library"
}

variable "vsphere_password" {
  type        = string
  sensitive   = true
  description = "Password for vSphere_User"
}

variable "vsphere_insecure_connection" {
  type        = bool
  default     = false
  description = "Requires the target vCenter Server to have a valid, trust certificate"
}

variable "vsphere_folder" {
  type        = string
  default     = ""
  description = "Folder that the VM will temporarily be storaged in while before upload to the content library"
}

variable "vsphere_datacenter" {
  type        = string
  description = "Target Datacenter for the deployment"
}

variable "vsphere_compute_cluster" {
  type        = string
  description = "Target Cluster for the deployment"
}

variable "vsphere_portgroup_name" {
  type        = string
  description = "Target Portgroup/network for the deployment (PXE enabled with internet access for Windows patching)"
}

variable "vsphere_datastore" {
  type        = string
  default     = ""
  description = "Target Datacenter for the deployment"
}

// Virtual Machine Settings
variable "vm_name" {
  type        = string
  description = "Name of the VM (temporary)"
}

variable "vm_cpu_count" {
  type        = string
  default     = "2"
  description = "Amount of vCPU's that are to be allocated to the Template VM"
}

variable "vm_mem_size" {
  type        = string
  default     = "4096"
  description = "Amount of memory to be allocated to the template"
}

variable "vm_disk_size" {
  type        = string
  default     = "614400"
  description = "Size of the OS disk in MB"
}

variable "vm_firmware" {
  type        = string
  default     = "efi"
  description = "Firmware for the template"
}

variable "common_vm_version" {
  type        = string
  default     = "14"
  description = "VM Hardware Version.  Default should be the minimum common version for the versions of vSphere the template will be used"
}

variable "vm_guest_os_type" {
  type        = string
  description = "Version of the guest operating system.  This uses the VMware OS type codes"
}

variable "vm_disk_controller_type" {
  type        = list(string)
  default     = ["lsilogic"]
  description = "VM disk controller type"
}

variable "vm_disk_thin_provisioned" {
  type        = bool
  default     = true
  description = "Disk type, Thin/Thick etc"
}

variable "vm_network_card" {
  type        = string
  default     = "vmxnet3"
  description = "Virtual NIC type"
}

variable "os_iso_path" {
  type        = string
  description = "Path to the OS ISO file including the datastore name"
}

variable "vmtools_iso_path" {
  type        = string
  default     = "[] /usr/lib/vmware/isoimages/windows.iso"
  description = "Path to the VMware Tools ISO file including the datastore name"
}

// Boot and Provisioning Settings
variable "vm_boot_wait" {
  type        = string
  default     = "5s"
  description = "Delay in seconds for when Packer should begin sending the boot command key strokes"
}

variable "vm_boot_command" {
  type        = list(string)
  default     = ["a<enter><wait>a<enter><wait>a<enter><wait>a<enter>"]
  description = "Boot command key strokes to be sent to the VM"
}

variable "vm_boot_order" {
  type    = string
  default = "disk,cdrom"
}

variable "vm_shutdown_command" {
  type        = string
  description = "Command(s) for guest operating system shutdown."
}

// Communicator Settings and Credentials
variable "build_username" {
  type        = string
  sensitive   = true
  description = "Windows user to continue configuration"
}

variable "build_password" {
  type        = string
  sensitive   = true
  description = "Password for winrm_user"
}

variable "winrm_timeout" {
  type        = string
  default     = "30m"
  description = "Timeout value for how long Packer should wait for WinRM to become available once an IP has been assigned"
}

// Template and Content Library Settings
variable "common_template_conversion" {
  type        = bool
  description = "Convert the virtual machine to template. Must be 'false' for content library."
  default     = false
}

variable "common_content_library_name" {
  type        = string
  description = "The name of the target vSphere content library, if used."
  default     = null
}

variable "common_content_library_ovf" {
  type        = bool
  description = "Export to content library as an OVF template."
  default     = true
}

variable "common_content_library_destroy" {
  type        = bool
  description = "Delete the virtual machine after exporting to the content library."
  default     = true
}

variable "common_content_library_skip_export" {
  type        = bool
  description = "Skip exporting the virtual machine to the content library. Option allows for testing/debugging without saving the machine image."
  default     = false
}

// Scripts and config files
variable "config_files" {
  type        = list(string)
  default     = []
  description = "Specify all files and folders that need to be made available to the OS during install"
}
variable "script_files" {
  type        = list(string)
  default     = []
  description = "Specify all files and folders that need to be made available AFTER the OS install"
}

// Installer Settings
variable "vm_inst_os_language" {
  type        = string
  description = "The installation operating system lanugage."
  default     = "en-US"
}

variable "vm_inst_os_keyboard" {
  type        = string
  description = "The installation operating system keyboard input."
  default     = "en-US"
}

variable "vm_inst_os_image" {
  type        = string
  description = "The installation operating system image input."
}

variable "vm_inst_os_kms_key" {
  type        = string
  description = "The installation operating system KMS key input."
}

variable "vm_guest_os_language" {
  type        = string
  description = "The guest operating system lanugage."
  default     = "en-US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The guest operating system keyboard input."
  default     = "en-US"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The guest operating system timezone."
  default     = "UTC"
}

// Network settings
variable "vm_guest_os_ipv4_address" {
  type        = string
  description = "IP address of VM network adapter"
  default     = "192.168.0.10"
}

variable "vm_guest_os_ipv4_prefix" {
  type        = string
  description = "Network prefix for VM network adapter"
  default     = "24"
}

variable "vm_guest_os_ipv4_route" {
  type        = string
  description = "Default route of VM network adapter"
  default     = "192.168.0.1"
}

variable "vm_guest_os_ipv4_dns1" {
  type        = string
  description = "Primary DNS for VM network adapter"
  default     = "192.168.0.1"
}

variable "vm_guest_os_ipv4_dns2" {
  type        = string
  description = "Secondary DNS for VM network adapter"
  default     = "1.1.1.1"
}
