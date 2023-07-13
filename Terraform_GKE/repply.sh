#!/bin/sh

gcloud iam workload-identity-pools undelete github-actions --location=global
gcloud iam workload-identity-pools providers undelete github-actions-oidc --workload-identity-pool=github-actions --location=global

terraform import google_iam_workload_identity_pool.github_actions projects/triple-nectar-391006/locations/global/workloadIdentityPools/github-actions
terraform import google_iam_workload_identity_pool_provider.github_actions_oidc projects/triple-nectar-391006/locations/global/workloadIdentityPools/github-actions/providers/github-actions-oidc

terraform apply
