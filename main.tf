# Downloads a file (boot image or disk image) from a URL straight into a Proxmox datastore.
# Proxmox downloads it from its own network: nothing goes through the machine that runs Terraform.

# Existing states created with the deprecated resource name move to the short name without a re-download.
moved {
  from = proxmox_virtual_environment_download_file.this
  to   = proxmox_download_file.this
}

resource "proxmox_download_file" "this" {
  node_name    = var.node_name
  datastore_id = var.datastore_id
  content_type = var.content_type
  url          = var.url
  file_name    = var.file_name

  checksum                = var.checksum
  checksum_algorithm      = var.checksum != null ? var.checksum_algorithm : null
  decompression_algorithm = var.decompression_algorithm

  overwrite           = var.overwrite
  overwrite_unmanaged = var.overwrite_unmanaged
  upload_timeout      = var.upload_timeout
  verify              = var.verify_tls
}
