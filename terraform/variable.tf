variable ansible_hosts_file {
  type        = string
  description = "ansible hosts path"
}

variable instance_ssh_key_name {
  type        = string
  description = "ssh key for instance created by terraform"
}

variable instance_ssh_key_path {
  type        = string
  description = "ssh key path for instance created by terraform"
}

variable hosts_file {
  type        = string
  description = "hosts file name"
}

variable inventory_file {
  type        = string
  description = "inventory file name"
}

