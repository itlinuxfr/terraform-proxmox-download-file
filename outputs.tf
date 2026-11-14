output "id" {
  description = "Volume ID of the file (for example local:iso/talos.iso). Use it as the file_id of a VM CD-ROM, or to import a disk."
  type        = string
  value       = proxmox_download_file.this.id
}

output "file_name" {
  description = "Name of the stored file."
  type        = string
  value       = proxmox_download_file.this.file_name
}

output "datastore_id" {
  description = "ID of the datastore that stores the file."
  type        = string
  value       = proxmox_download_file.this.datastore_id
}

output "node_name" {
  description = "Name of the node that downloaded the file."
  type        = string
  value       = proxmox_download_file.this.node_name
}

output "content_type" {
  description = "Proxmox content type of the file."
  type        = string
  value       = proxmox_download_file.this.content_type
}

output "size" {
  description = "Size of the file on the datastore, in bytes."
  type        = number
  value       = proxmox_download_file.this.size
}
