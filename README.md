terraform-gcp-bootstrap
=======================

# Introduction

I want to use Terraform for handling GCP projects. To reduce the radius blast,
I create a bucket for each project (unfortunately GCP doesn't backup buckets).

# First step

The first step is to create the project that will store TF states.

1. Clone this repository
```
$ git clone git@github.com:sdouche/terraform-gcp-bootstrap.git
```

2. Go to providers/google/bootstrap

3. Create a file `terraform.tfvars` with 3 variables : `org_id`,
   `billing_account` and `tf_project_name`:
```
org_id = "ORG_ID"
billing_account = "BILLING_ID"
tf_project_name = "MY_PROJECT_NAME"

```

**Note**: To know the organization ID and the billing account ID
```bash
$ gcloud organizations list
$ gcloud beta billing accounts list
```

4. Launch the bootstrap script:
```
$ ./bootstrap.sh
$ terraform init
$ terraform apply
```

Now the GCP project for storing all top level objects (like folders and
projects) is created.

# Creating projects

Create a project with the script `create-gcp-project.sh`

Example with a project named test:
```
$ cd terraform-gcp-boostrap/providers/google/bootstrap/
$ ./create-gcp-project.sh -n test
$ cd ../projects/test
$ <ADD RESOURCES> 
$ terraform init
$ terraform apply
```
