#!/bin/bash

# use all ip's in advertise client urls
NODE_NAME="etcd-"`hostname`
LCU="http://0.0.0.0:2379,http://0.0.0.0:4001"
ACU=""
for ip in `hostname -I`; do
    if [ -n "$ACU" ]; then
        ACU="http://$ip:2379,http://$ip:4001"
    else
        ACU="$ACU,http://$ip:2379,http://$ip:4001"
    fi
done
if [ -n "$ACU" ]; then
    ./etcd -name $NODE_NAME -listen-client-urls $LCU -advertise-client-urls $ACU
else
    echo "ip adress not found"
fi

