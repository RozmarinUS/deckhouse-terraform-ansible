#!/bin/bash


THIS=`readlink -f "${BASH_SOURCE[0]}"`
DIR=`dirname "${THIS}"`
pushd $DIR

source ../terraform_output.sh
ssh $admin_username@$ip_address_kube_worker_1

popd