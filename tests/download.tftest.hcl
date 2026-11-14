# Tests without real infrastructure: the Proxmox provider is replaced by a mock provider.
# `command = plan` creates nothing. Outputs that come from the API (id, size) are not checked here.

mock_provider "proxmox" {}

variables {
  node_name    = "pve-test"
  datastore_id = "local"
  url          = "https://example.com/talos.iso"
}

run "safe_defaults" {
  command = plan

  assert {
    condition = (
      proxmox_download_file.this.content_type == "iso" &&
      proxmox_download_file.this.overwrite == false &&
      proxmox_download_file.this.overwrite_unmanaged == false &&
      proxmox_download_file.this.verify == true &&
      proxmox_download_file.this.upload_timeout == 600
    )
    error_message = "Defaults must be: iso, no overwrite, no unmanaged overwrite, TLS verified, 600 seconds."
  }

  assert {
    condition     = proxmox_download_file.this.checksum == null && proxmox_download_file.this.checksum_algorithm == null
    error_message = "Without a checksum, no checksum and no algorithm must be sent to the provider."
  }

  assert {
    condition     = proxmox_download_file.this.decompression_algorithm == null
    error_message = "Without decompression_algorithm, the file must be kept as downloaded."
  }
}

run "import_compressed_disk_image" {
  command = plan

  variables {
    content_type            = "import"
    url                     = "https://example.com/talos.raw.zst"
    file_name               = "talos.raw"
    decompression_algorithm = "zst"
  }

  assert {
    condition = (
      proxmox_download_file.this.content_type == "import" &&
      proxmox_download_file.this.file_name == "talos.raw" &&
      proxmox_download_file.this.decompression_algorithm == "zst"
    )
    error_message = "content_type, file_name and decompression_algorithm must reach the provider."
  }
}

run "checksum_sha256" {
  command = plan

  variables {
    checksum = format("%064d", 1)
  }

  assert {
    condition     = proxmox_download_file.this.checksum == format("%064d", 1) && proxmox_download_file.this.checksum_algorithm == "sha256"
    error_message = "A checksum must be sent with the default algorithm sha256."
  }
}

run "checksum_sha512" {
  command = plan

  variables {
    checksum           = format("%0128d", 1)
    checksum_algorithm = "sha512"
  }

  assert {
    condition     = proxmox_download_file.this.checksum_algorithm == "sha512"
    error_message = "The checksum algorithm must reach the provider."
  }
}

run "options_passed_to_provider" {
  command = plan

  variables {
    overwrite           = true
    overwrite_unmanaged = true
    verify_tls          = false
    upload_timeout      = 1200
  }

  assert {
    condition = (
      proxmox_download_file.this.overwrite == true &&
      proxmox_download_file.this.overwrite_unmanaged == true &&
      proxmox_download_file.this.verify == false &&
      proxmox_download_file.this.upload_timeout == 1200
    )
    error_message = "overwrite, overwrite_unmanaged, verify_tls and upload_timeout must reach the provider."
  }
}
