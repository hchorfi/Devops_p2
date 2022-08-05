#!/bin/bash

######## stupid implimentation (just for test)#######

INV=./hosts
TERR_HOSTS=./../terraform/hosts

build_inv () {
    echo "[masters]" > $INV
    cat $TERR_HOSTS | sed -e 's/^/ansible_host=/' | awk '{print $2, $1}' | sort | grep master >> $INV
    echo "\n[workers]" >> $INV
    cat $TERR_HOSTS | sed -e 's/^/ansible_host=/' | awk '{print $2, $1}' | sort | grep worker >> $INV
    echo "\n[masters:vars]"  >> $INV
    echo "ansible_ssh_private_key_file=~/.ssh/aws_terraform.cer" >> $INV
    echo "ansible_user=ubuntu" >> $INV
    echo "\n[workers:vars]" >> $INV
    echo "ansible_ssh_private_key_file=~/.ssh/aws_terraform.cer" >> $INV
    echo "ansible_user=ubuntu" >> $INV
}

if [ -f "$INV" ];then
    echo "" > $INV
    build_inv
else
    touch $INV
    build_inv
fi
