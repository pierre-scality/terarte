output "region" {
  value = var.region
}

output "ami" {
  value = lookup(var.available_images, "${var.region}.${var.os}")
} 
   
