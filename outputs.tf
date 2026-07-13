output "instance_public_ip" {
  description = "Public IP of the web server"
  value       = "https://${aws_instance.my_first_demo.public_ip}"
}