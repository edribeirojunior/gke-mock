variable "name" {
  description = "Project Name"
  default= "gke-service-project"
}

variable "activate_apis" {
  description = "Google Apis required list for the project e.g. iam.googleapis.com,container.googleapis.com"
  default     = "iam.googleapis.com,container.googleapis.com,compute.googleapis.com"
}

variable "apis_authority" {
  default = false
}

variable "org_id" {
  description = "Organization ID"
  default     = ""
}

variable "folder_id" {
  description = "Folder ID"
  default     = "184515897165"
}

variable "credentials_path" {
  default = "sa_account.json"
}

variable "shared_vpc_project" {
  type        = string
  default     = "edsharedvpc-1"
  description = "ID from a Shared VPC Host Project"
}

variable "shared_vpc_project_name" {
  type        = string
  default = "vpc-edsharedvpc-1"
  description = "Name from a VPC from Shared VPC Project"

}

variable "admin_group_email" {
  description = "Admin Group e.g. group:admins@example.com or user:admin@example.com"
  default     = "group:admin@inspiracaosoluvel.com"
}

variable "user_group_email" {
  description = "User Group e.g. group:users@example.com or user:user@example.com"
  default     = "group:users@inspiracaosoluvel.com"
}

variable "disable_services_on_destroy" {
  default = "true"
  type    = string
}

variable "disable_dependent_services" {
  default = "true"
  type    = string
}

variable "primary_ip_cidr_range" {
  description = "Primary IP Range for the Subnet"
  default = "192.168.1.0/24"
  type        = string
}

variable "secondary_ip_cidr_range" {
  description = "Secondary IP Range for the Subnet"
  default = "192.168.2.0/24"
  type        = string
}

variable "environment" {
  description = "Environment Label related to this Project"
  default = "staging"
}

variable "region" {
  description = "Location for the GKE Cluster e.g. southamerica-east1 to Regional and southamerica-east1-a for Zonal"
  default = "southamerica-east1"
}



