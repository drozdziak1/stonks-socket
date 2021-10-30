#!/bin/sh

pushd "module"
docker build -t stonks-builder .

if !(docker run --name stonks-builder -v "$PWD:/pwd" stonks-builder make -C /pwd); then
    docker rm stonks-builder
    echo "kernel module build failed"
    exit
fi
docker cp stonks-builder:/pwd/stonks_socket.ko ../
docker cp stonks-builder:/boot/vmlinuz-5.11.0-38-generic ../
docker rm stonks-builder
popd

