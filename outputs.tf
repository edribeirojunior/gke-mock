output "project_name" {
  value = module.project.project_name
}

output "project_id" {
  value = module.project.project_id
}

output "project_number" {
  value = module.project.project_number
}

output "service_account_id" {
  value       = module.project.service_account_id
  description = "The id of the default service account"
}

output "service_account_display_name" {
  value       = module.project.service_account_display_name
  description = "The display name of the default service account"
}

output "service_account_email" {
  value       = module.project.service_account_email
  description = "The email of the default service account"
}

output "service_account_name" {
  value       = module.project.service_account_name
  description = "The fully-qualified name of the default service account"
}

output "service_account_unique_id" {
  value       = module.project.service_account_unique_id
  description = "The unique id of the default service account"
}


output "gke_name" {
  description = "GKE Cluster name"
  value       = module.gke.name
}


output "gke_location" {
  description = "GKE Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.gke.location
}

output "gke_node_pools_versions" {
  description = "List of node pools versions"
  value       = module.gke.node_pools_versions
}

output "gke_node_pools_names" {
  description = "List of node pools names"
  value       = module.gke.node_pools_names
}

output "gke_master_version" {
  description = "Current master kubernetes version"
  value       = module.gke.master_version
}

output "gke_network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = module.gke.network_policy_enabled
}

output "gke_http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = module.gke.http_load_balancing_enabled
}

output "gke_horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = module.gke.horizontal_pod_autoscaling_enabled
}

output "gke_kubernetes_dashboard_enabled" {
  description = "Whether kubernetes dashboard enabled"
  value       = module.gke.kubernetes_dashboard_enabled
}



