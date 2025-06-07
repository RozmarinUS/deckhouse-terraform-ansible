#!/bin/bash

THIS=$(readlink -f "${BASH_SOURCE[0]}")
DIR=$(dirname "${THIS}")
pushd $DIR/terraform
terraform apply -auto-approve
terraform output | sed 's/^\([a-zA-Z0-9_-]*\).*[[:space:]]*=[[:space:]]*\(.*\).*$/export \1=\2/' | tee ../terraform_output.sh
popd
