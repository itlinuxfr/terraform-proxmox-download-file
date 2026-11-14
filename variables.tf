variable "node_name" {
  description = "Name of the Proxmox node that downloads the file."
  type        = string
  nullable    = false

  validation {
    condition     = trimspace(var.node_name) != ""
    error_message = "The node name must not be empty."
  }
}

variable "datastore_id" {
  description = "ID of the Proxmox datastore that stores the file (for example local). It must allow the chosen content type."
  type        = string
  nullable    = false

  validation {
    condition     = trimspace(var.datastore_id) != ""
    error_message = "The datastore ID must not be empty."
  }
}

variable "url" {
  description = "HTTPS URL of the file to download."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^https://[^[:space:]]+$", var.url))
    error_message = "The URL must start with https:// and contain no space. Plain http:// is refused."
  }
}

variable "content_type" {
  description = "Proxmox content type: iso for a boot image, import for a disk image to import as a VM disk."
  type        = string
  default     = "iso"
  nullable    = false

  validation {
    condition     = contains(["iso", "import"], var.content_type)
    error_message = "The content type must be iso or import."
  }
}

variable "file_name" {
  description = "Name of the stored file. Null derives it from the URL. For the iso content type it must end with .iso or .img."
  type        = string
  default     = null

  validation {
    condition     = var.file_name == null ? true : (trimspace(var.file_name) != "" && !strcontains(var.file_name, "/"))
    error_message = "The file name must not be empty and must not contain a slash."
  }

  validation {
    condition     = var.file_name == null || var.content_type != "iso" ? true : can(regex("\\.(iso|img)$", var.file_name))
    error_message = "For the iso content type, the file name must end with .iso or .img."
  }
}

variable "checksum" {
  description = "Expected checksum of the downloaded file, in hexadecimal. Null skips the integrity check."
  type        = string
  default     = null

  validation {
    condition     = var.checksum == null ? true : can(regex("^[0-9a-fA-F]+$", var.checksum))
    error_message = "The checksum must be a hexadecimal string."
  }

  validation {
    condition     = var.checksum == null ? true : length(var.checksum) == lookup({ md5 = 32, sha1 = 40, sha224 = 56, sha256 = 64, sha384 = 96, sha512 = 128 }, var.checksum_algorithm, -1)
    error_message = "The checksum length does not match checksum_algorithm (md5 32, sha1 40, sha224 56, sha256 64, sha384 96, sha512 128 characters)."
  }
}

variable "checksum_algorithm" {
  description = "Algorithm of the checksum: md5, sha1, sha224, sha256, sha384 or sha512. Only used when checksum is set."
  type        = string
  default     = "sha256"
  nullable    = false

  validation {
    condition     = contains(["md5", "sha1", "sha224", "sha256", "sha384", "sha512"], var.checksum_algorithm)
    error_message = "The checksum algorithm must be md5, sha1, sha224, sha256, sha384 or sha512."
  }
}

variable "decompression_algorithm" {
  description = "Decompress the downloaded file with this algorithm: gz, lzo, zst or bz2. Null keeps the file as downloaded."
  type        = string
  default     = null

  validation {
    condition     = var.decompression_algorithm == null ? true : contains(["gz", "lzo", "zst", "bz2"], var.decompression_algorithm)
    error_message = "The decompression algorithm must be gz, lzo, zst or bz2."
  }
}

variable "overwrite" {
  description = "Replace the file when it changes (size changed on the datastore, or new size reported by the URL). False never replaces a file that Terraform manages, which avoids a silent re-download."
  type        = bool
  default     = false
  nullable    = false
}

variable "overwrite_unmanaged" {
  description = "Delete and replace a file with the same name that Terraform does not manage. False fails if the file already exists."
  type        = bool
  default     = false
  nullable    = false
}

variable "upload_timeout" {
  description = "Download timeout in seconds."
  type        = number
  default     = 600
  nullable    = false

  validation {
    condition     = var.upload_timeout > 0
    error_message = "The timeout must be greater than zero."
  }
}

variable "verify_tls" {
  description = "Verify the TLS certificate of the source URL. Disable only for a source with a private certificate authority that Proxmox does not trust."
  type        = bool
  default     = true
  nullable    = false
}
