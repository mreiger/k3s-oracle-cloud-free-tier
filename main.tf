module "free-tier-k3s" {
  source = "./modules/free-tier-k3s"

  # General
  project_name   = "ftk3s"
  region         = var.region
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqjz5ekixwxvlcnb3ic772b6i5a6romkvov2frp7qk2cwe33c57yq"
  ssh_public_key = file("~/.ssh/id_ed25519.pub")

  # Network
  whitelist_subnets = [
    "0.0.0.0/0",
    "10.0.0.0/8"
  ]

  vcn_subnet     = "10.0.0.0/16"
  # private_subnet = "10.0.2.0/23"
  public_subnet  = "10.0.0.0/23"

  freetier_server_ad_list = 2
  freetier_worker_ad_list = [ 1, 2, 3 ]
}
