#!/bin/bash

THIS=$(readlink -f "${BASH_SOURCE[0]}")
DIR=$(dirname "${THIS}")
pushd $DIR

cd terraform/misc
./get_debian.sh
popd
