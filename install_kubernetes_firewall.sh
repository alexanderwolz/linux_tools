#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR/common.sh"

check4root

echo "Setting UFW rules for Kubernetes..."
echo "-----------------------------------"
apt-get update
apt-get install ufw

#setup default ports
ufw allow https

#setup k8s ports
ufw allow 179/tcp
ufw allow 4789/tcp
ufw allow 5473/tcp
ufw allow 6443/tcp
ufw allow 2379/tcp
ufw allow 4149/tcp
ufw allow 10250/tcp
ufw allow 10255/tcp
ufw allow 10256/tcp
ufw allow 9099/tcp

ufw enable

echo "Done"
