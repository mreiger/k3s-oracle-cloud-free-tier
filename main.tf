module "free-tier-k3s" {
  source = "./modules/free-tier-k3s"

  # General
  project_name   = "ftk3s"
  region         = var.region
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaauzgz6yt7shalunmdpmlhb4ccgpf2rkhfvuml7667tx72az47ulaq"
  ssh_public_key = file("~/.ssh/id_oci_kubernetes.pub")

  # Network
  whitelist_subnets = [
    "108.45.88.50/32",
    "10.0.0.0/8"
  ]

  vcn_subnet     = "10.0.0.0/16"
  private_subnet = "10.0.2.0/23"
  public_subnet  = "10.0.0.0/23"

  freetier_server_ad_list = 3
  freetier_worker_ad_list = [ 3 ]
}