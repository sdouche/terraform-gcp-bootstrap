#!/usr/bin/env bash

set -e

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-n NAME]
Create the useful boilerplate to use Terraform on a project.

    -h          display this help and exit
    -n NAME     name of the project
EOF
}
name=""

OPTIND=1

while getopts n: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        n)  name=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"

source <(grep = terraform.tfvars | sed 's/ *= */=/g')
source ../../../lib/utils.sh

credentials="~/.config/gcloud/${tf_project_name}.json"

e_header "BEGIN"

e_arrow "Create the directory"
mkdir -p ../projects/${name}

e_arrow "Create the backend.tf file"
cat > ../projects/${name}/backend.tf <<EOF
terraform {
 backend "gcs" {
    credentials = "${credentials}"
    project     = "${tf_project_name}"
    bucket      = "${name}"
    prefix      = "/terraform.tfstate"
  }
}
EOF


e_arrow "Create the provider.tf file"
cat > ../projects/${name}/provider.tf <<EOF
provider "google" {
  project     = "${name}"
}
EOF

e_arrow "Set the gcloud project"
gcloud config set project ${name}

e_header "END"
