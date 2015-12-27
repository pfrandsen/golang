#!/bin/bash

# use 192.*.*.* ip in advertise client urls
NODE_NAME="etcd-"`hostname`
LCU="http://0.0.0.0:2379,http://0.0.0.0:4001"
ACU=""
# find 192.* adress and use that for advertise client urls
for ip in `hostname -I`; do
    if [[ $ip =~ 192\..* ]]; then
        ACU="http://$ip:2379,http://$ip:4001"
        PUBLIC_IP=$ip
    fi
done
if [ -n "$ACU" ]; then
    ./etcd -name $NODE_NAME -listen-client-urls $LCU -advertise-client-urls $ACU
else
    echo "192.*.*.* adress not found"
fi

