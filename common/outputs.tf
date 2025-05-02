output "this_name" {
    value = var.this_name
}

output "private_key_pem" {
  value     = tls_private_key.ed25519.private_key_openssh
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.ed25519.public_key_openssh
}
