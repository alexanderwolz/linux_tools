#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR/common.sh"

check4root

echo "checking for Docker..."
echo "-----------------------------------"
which docker >/dev/null
if [  $? -ne 0 ]; then
    echo "Error: Docker is not installed on this machine"
    exit 1
fi

echo "disabling SWAP partitions..."
echo "-----------------------------------"
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a


echo "installing Kubernetes..."
echo "-----------------------------------"
apt-get update
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
