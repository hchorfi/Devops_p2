output "instance_msters_ip_addr" {
  value = aws_instance.master.*.public_ip
}

output "instance_workers_ip_addr" {
  value = aws_instance.worker.*.public_ip
}

