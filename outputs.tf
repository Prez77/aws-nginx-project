# outputs.tf
output "nginx_public_ip" {
  description = "The public IP address of the Nginx web server"
  value       = aws_instance.nginx_web_server.public_ip
}

output "nginx_public_dns" {
  description = "The public DNS name of the Nginx web server"
  value       = aws_instance.nginx_web_server.public_dns
}
