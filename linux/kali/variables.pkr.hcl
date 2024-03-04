// vSphere Credentials

variable "vsphere_endpoint" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_insecure_connection" {
  type        = bool
  description = "Do not validate vCenter Server TLS certificate."
}

// vSphere Settings

variable "vsphere_datacenter" {
  type        = string
  description = "The name of the target vSphere datacenter."
  default     = ""
}

variable "vsphere_cluster" {
  type        = string
  description = "The name of the target vSphere cluster."
  default     = ""
}

variable "vsphere_datastore" {
  type        = string
  description = "The name of the target vSphere datastore."
}

variable "vsphere_network" {
  type        = string
  description = "The name of the target vSphere network segment."
}

variable "vsphere_folder" {
  type        = string
  description = "The name of the target vSphere folder."
  default     = ""
}

// VM settings
variable "root_password" {
  type        = string
  description = "Root password to be set"
}

variable "root_ssh_key" {
  type        = string
  description = "Root SSH key"
}

variable "kali_version" {
  type        = string
  description = "Kali Linux ISO image URL"
  default     = "2024.1"
}

variable "kali_iso_path" {
  type        = string
  description = "Local path to Kali Linux ISO"
  default     = "[Datastore1] ISO\\Kali.iso"
}

variable "kali_iso_checksum" {
  type        = string
  description = "Kali Linux ISO checksum"
  default     = "sha256:c150608cad5f8ec71608d0713d487a563d9b916a0199b1414b6ba09fce788ced"
}

variable "kali_user_name" {
  type        = string
  description = "Default Kali username"
  default     = "kali"
}

variable "kali_user_password" {
  type        = string
  description = "Default kali user's password"
  default     = "kali"
}

variable "kali_user_ssh_key" {
  type        = string
  description = "Default kali user's SSH key"
  default     = null
}

variable "kali_user_fullname" {
  type        = string
  description = "Default kali user's fullname"
  default     = "Kali User"
}