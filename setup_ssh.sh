#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR/common.sh"

check4root

while true; do
    read -p "Do you wish to setup SSH configs for this host? [y/n] " selection
    case $selection in
    [y]*) break ;;
    [n]*) exit ;;
    *) echo "Please answer y or n." ;;
    esac
done

AUTH_KEYS="/root/.ssh/authorized_keys"
if [ ! -f "$AUTH_KEYS" ]; then
	echo "There are no public keys set, upload them first using e.g. 'ssh-copy-id'"
	exit 1
fi

# Check RSA Keys otherwise create them
RSA_KEY="/root/.ssh/id_rsa"
if [ ! -f $RSA_KEY ]; then
	echo "Creating RSA key.."
	echo "-----------------------------------"
	ssh-keygen -b 4096 -f $RSA_KEY -N '' <<< y
fi

echo "Changing SSH Settings..."
echo "-----------------------------------"

SEPARATOR="# Changes made by Setup Script:"
SSH_PORT="22"
SSHD_FILE="/etc/ssh/sshd_config"
SSHD_BKP="$SSHD_FILE.bak"

if [ ! -f $SSHD_BKP ]; then
	cp $SSHD_FILE $SSHD_BKP
else
	cp $SSHD_BKP $SSHD_FILE
fi

echo "" >> $SSHD_FILE
echo "$SEPARATOR" >> $SSHD_FILE
echo "Port $SSH_PORT" >>  $SSHD_FILE
echo "PubkeyAuthentication yes" >> $SSHD_FILE
echo "PermitRootLogin prohibit-password" >> $SSHD_FILE
echo "PasswordAuthentication no" >> $SSHD_FILE
echo "" >> $SSHD_FILE

echo "Done"
