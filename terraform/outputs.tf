output "instances" {
  value = {
    ubuntu  = aws_instance.ubuntu.public_ip
    centos  = aws_instance.centos.public_ip
    windows = aws_instance.windows.public_ip
  }
}
