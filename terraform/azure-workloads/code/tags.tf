module "tags" {
  source = "../../modules/common-tags"

  pipeline_name = var.pipeline_name
  repo_name     = var.repo_name
  branch_name   = var.branch_name
  repo_uri      = var.repo_uri
  date          = var.date
  run_number    = var.run_number
  environment   = var.environment
}