output "external_ip_address_gitlab-ci" {
  value = yandex_compute_instance.gitlab-ci-vm[*].network_interface.0.nat_ip_address
}
