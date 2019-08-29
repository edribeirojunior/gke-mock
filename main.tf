terraform {
  required_version = "~> 0.12"
  backend "gcs" {
      bucket = "gcp-foundation-build-projects"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Locals
# ----------------------------------------------------------------------------------------------------------------------

locals {
  identifier = "${lower(var.name)}"
}

# ----------------------------------------------------------------------------------------------------------------------
# Project
# ----------------------------------------------------------------------------------------------------------------------

module "project" {
  source             = "git::git@gitlab.com:mandic-labs/terraform/modules/gcp/project.git?ref=master"
  name               = "${var.name}"
  admin_group_email  = "${var.admin_group_email}"
  admin_group_role   = "roles/owner"
  user_group_email   = "${var.user_group_email}"
  user_group_role    = "roles/viewer"
  org_id             = "${var.org_id}"
  project_id         = "${var.name}"
  shared_vpc         = "true"
  shared_vpc_project = "${var.shared_vpc_project}"
  billing_account    = "01BD07-2E6EE4-EDF01B"
  folder_id          = "${var.folder_id}"
  activate_apis      = "${var.activate_apis}"
  //apis_authority              = "${var.apis_authority}"
  manage_group                = var.admin_group_email != "" ? true : false
  disable_services_on_destroy = var.disable_services_on_destroy
  disable_dependent_services  = var.disable_dependent_services
  environment                 = var.environment
}

# ----------------------------------------------------------------------------------------------------------------------
# Shared VPC Service
# ----------------------------------------------------------------------------------------------------------------------

module "shared-vpc-service" {
  source = "git::git@gitlab.com:mandic-labs/terraform/modules/gcp/shared-vpc-service.git?ref=master"
  host_project_name = "${var.shared_vpc_project}"
  service_project_name = "${module.project.project_id}"
}

# ----------------------------------------------------------------------------------------------------------------------
# Shared VPC Subnet
# ----------------------------------------------------------------------------------------------------------------------

module "subnet" {
  source = "git::git@gitlab.com:mandic-labs/terraform/modules/gcp/subnet.git?ref=master"
  project_id = "${var.shared_vpc_project}"
  name = "${var.name}"
  subnet_region = "southamerica-east1"
  vpc_name = "${var.shared_vpc_project_name}"
  ip_cidr_range = "${var.primary_ip_cidr_range}"
  secondary_ip_range_name = "${var.name}-secondary"
  secondary_ip_cidr = "${var.secondary_ip_cidr_range}"
}

# ----------------------------------------------------------------------------------------------------------------------
# GKE
# ----------------------------------------------------------------------------------------------------------------------

module "gke" {
  source = "git::git@gitlab.com:mandic-labs/terraform/modules/gcp/gke.git?ref=master"
  project_id                 = "${module.project.project_id}"
  service_account            = "${module.project.project_id}-compute@developes.gserviceaccount.com"
  project_filter_id          = "name:${var.name}"
  name                       = "${var.name}"
  regional                   = true
  network                    = "${var.shared_vpc_project_name}"
  subnetwork                 = "${var.name}"
  ip_range_pods              = "${var.name}-secondary"
  ip_range_services          = "${var.name}-secondary"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  kubernetes_dashboard       = true
  network_policy             = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 3
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = "project-service-account@${module.project.project_id}.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "${var.name}-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "${var.name}-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

