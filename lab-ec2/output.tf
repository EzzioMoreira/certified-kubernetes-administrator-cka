output "public_ip" {
  value = zipmap(aws_instance.web[*].tags.Name, aws_instance.web[*].public_ip)
}
