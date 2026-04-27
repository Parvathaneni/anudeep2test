variable "workspace_config" {
  description = "Legacy or manually supplied workspace config entries."
  type        = map(any)
  default     = {}
}

locals {
  workspace_request_files = fileset("${path.module}/workspace-requests", "**/*.json")

  workspace_request_maps = [
    for request_file in local.workspace_request_files :
    jsondecode(file("${path.module}/workspace-requests/${request_file}"))
  ]

  workspace_config_from_requests = length(local.workspace_request_maps) == 0 ? {} : merge(local.workspace_request_maps...)

  effective_workspace_config = merge(
    var.workspace_config,
    local.workspace_config_from_requests
  )
}

# Use local.effective_workspace_config wherever the factory currently uses
# var.workspace_config.
#
# Example:
#
# module "iacm_workspaces" {
#   source           = "./modules/iacm-workspace"
#   workspace_config = local.effective_workspace_config
# }
