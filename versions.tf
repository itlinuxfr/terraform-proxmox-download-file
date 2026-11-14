terraform {
  # 1.15 adds explicit type constraints on outputs, used in outputs.tf.
  required_version = ">= 1.15"

  # A module declares a lower bound only: the live repository pins exact versions.
  # 0.100.0 is the first release with proxmox_download_file, the short-name resource. The long name
  # proxmox_virtual_environment_download_file is deprecated and is removed in provider v1.0.
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.100.0"
    }
  }
}
