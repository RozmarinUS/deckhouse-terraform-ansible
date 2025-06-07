#!/bin/bash

THIS=$(readlink -f "${BASH_SOURCE[0]}")
DIR=$(dirname "${THIS}")
pushd "$DIR" || exit

mkdir -p ~/.images
mkdir -p ../modules/node/sources/

if [ ! -f ~/.images/debian12-cloud.qcow2 ]; then
    echo "Image not found, downloading"
    curl -L -o ~/.images/debian12-cloud.qcow2 https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
    qemu-img resize ~/.images/debian12-cloud.qcow2 30G
fi

ln -sf ~/.images/debian12-cloud.qcow2 ../modules/node/sources/debian12.qcow2

popd || exit
