# Create a new Google Cloud Platform project with terraform

The file `main.tf` creates a new, empty project in Google Cloud Platform, with
the minimum set of APIs enabled to allow terraform to manage the project.

Billing can't be enabled by terraform.  Ask someone to do that for you.

## Prerequisites

1. `gcloud`
1. `terraform`

## Create the project

1. Authorise yourself with `gcloud auth application-default login`. Terraform
   will use `gcloud` to enable two particular APIs that must be enabled before
   terraform can itself enable other APIs.
1. `terraform init`
1. `terraform apply`

If you get the following error, then do as it says.  Wait a few minutes, and
then `terraform apply` again

> `Error: Error creating Dataset: googleapi: Error 403: BigQuery API has not been used in project 409103136735 before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/bigquery.googleapis.com/overview?project=409103136735 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.`

## Disabling an API

[Terraform won't disable an API once it has been
created](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service#import).
APIs can only be disabled manually in the console or with `gcloud`, for example:

```sh
gcloud services disable storage.googleapis.com --project my-test-project
```

## References

1. https://medium.com/rockedscience/how-to-fully-automate-the-deployment-of-google-cloud-platform-projects-with-terraform-16c33f1fb31f
2. https://gist.github.com/edonosotti/9a3e49b0ac28ad211fbda26d422eb3bc#file-main-tf
