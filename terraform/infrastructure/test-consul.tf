# Test resource to verify Consul backend
resource "null_resource" "test_consul" {
  provisioner "local-exec" {
    command = "echo 'Consul backend test successful'"
  }
}
