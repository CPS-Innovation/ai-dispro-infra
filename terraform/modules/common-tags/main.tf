locals {
  tags = {
    Pipeline            = var.pipeline_name
    Repository          = var.repo_name
    Branch              = var.branch_name
    RepoUri             = var.repo_uri
    PipelineLastRunDate = var.date
    Environment         = var.environment
  }
}