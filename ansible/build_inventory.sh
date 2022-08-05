#!/bin/bash


#cat hosts | sed -e 's/^/ansible_host=/' | awk '{print $2, $1}' | sort | sed '/worker/i test'

INV=./hostss

build_inv () {
    echo "[master]" >> $INV
    cat hosts | sed -e 's/^/ansible_host=/' | awk '{print $2, $1}' | sort | grep master > $INV
}

if [ -f "$INV" ];then
    echo "" > $INV
    build_inv
else
    touch $INV
fi
