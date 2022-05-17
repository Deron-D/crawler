#!/bin/bash

yc_compute_instance_vm=($(yc compute instance list | grep gitlab-ci-vm | awk -F\| '{print $3 $6}'))

if [ $# -lt 1 ]
then
        echo "Usage : $0 --list or $0 --host"
        exit
fi

case "$1" in

--list)
cat<<EOF
{
    "_meta": {
        "hostvars": {
            "${yc_compute_instance_vm[0]}": {
                "ansible_host": "${yc_compute_instance_vm[1]}"
            }
        }
    },
    "all": {
        "children": [
            "gitlab-ci-vm",
            "ungrouped"
        ]
    },
    "gitlab-ci-vm": {
        "hosts": [
            "${yc_compute_instance_vm[0]}"
        ]
    }
}
EOF
;;
--host)
cat<<EOF
{

}
EOF
;;
esac
