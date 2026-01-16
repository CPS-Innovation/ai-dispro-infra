module "tags" {
  source        = "git::https://dev.azure.com/CPSDTS/Case%20Progression/_git/tf-module-common-tags?ref=main"
  pipeline_name = var.pipeline_name
  repo_name     = var.repo_name
  branch_name   = var.branch_name
  repo_uri      = var.repo_uri
  date          = var.date
  environment   = var.environment
}