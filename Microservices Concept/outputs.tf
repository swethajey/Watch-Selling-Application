output "product_service_public_ip" {
  value = aws_instance.product_service.public_ip
}

output "order_service_public_ip" {
  value = aws_instance.order_service.public_ip
}

output "user_service_public_ip" {
  value = aws_instance.user_service.public_ip
}
