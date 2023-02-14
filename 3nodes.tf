output "storage_nodes_ips" {
  value = ["${aws_instance.storage-1.private_ip}", "${aws_instance.storage-2.private_ip}", "${aws_instance.storage-3.private_ip}"]
}   

