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
