# Input validation tests: each rejected value must fail the plan on the right variable.

mock_provider "proxmox" {}

variables {
  node_name    = "pve-test"
  datastore_id = "local"
  url          = "https://example.com/talos.iso"
}

run "plain_http_url_refused" {
  command = plan

  variables {
    url = "http://example.com/talos.iso"
  }

  expect_failures = [var.url]
}

run "url_with_space_refused" {
  command = plan

  variables {
    url = "https://example.com/talos image.iso"
  }

  expect_failures = [var.url]
}

run "empty_node_name_refused" {
  command = plan

  variables {
    node_name = " "
  }

  expect_failures = [var.node_name]
}

run "empty_datastore_refused" {
  command = plan

  variables {
    datastore_id = ""
  }

  expect_failures = [var.datastore_id]
}

run "invalid_content_type_refused" {
  command = plan

  variables {
    content_type = "vztmpl"
  }

  expect_failures = [var.content_type]
}

run "iso_with_wrong_extension_refused" {
  command = plan

  variables {
    file_name = "talos.qcow2"
  }

  expect_failures = [var.file_name]
}

run "file_name_with_slash_refused" {
  command = plan

  variables {
    file_name = "dir/talos.iso"
  }

  expect_failures = [var.file_name]
}

run "import_accepts_disk_image_name" {
  command = plan

  variables {
    content_type = "import"
    file_name    = "talos.qcow2"
  }
}

run "checksum_not_hexadecimal_refused" {
  command = plan

  variables {
    checksum = "not-a-checksum"
  }

  expect_failures = [var.checksum]
}

run "checksum_wrong_length_refused" {
  command = plan

  variables {
    checksum = "abc123"
  }

  expect_failures = [var.checksum]
}

run "checksum_does_not_match_algorithm_refused" {
  command = plan

  variables {
    checksum           = format("%064d", 1)
    checksum_algorithm = "sha512"
  }

  expect_failures = [var.checksum]
}

run "unknown_checksum_algorithm_refused" {
  command = plan

  variables {
    checksum_algorithm = "crc32"
  }

  expect_failures = [var.checksum_algorithm]
}

run "unknown_decompression_algorithm_refused" {
  command = plan

  variables {
    decompression_algorithm = "xz"
  }

  expect_failures = [var.decompression_algorithm]
}

run "zero_timeout_refused" {
  command = plan

  variables {
    upload_timeout = 0
  }

  expect_failures = [var.upload_timeout]
}
