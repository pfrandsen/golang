#!/bin/bash

NODESET="node-1 node-2 node-3 node-4"
PRE="etcd-"
NODE=`hostname`
NODE_NAME="${PRE}${NODE}"
CONTAINER_NAME="${NODE_NAME}-container"

# cannot use the following as Snappy does not have host command
# PUBLIC_IP=`host -t a $NODE | awk '{print $4}' | egrep ^[1-9]`
PUBLIC_IP=`ping -c 1 -I eth0 -W 1 $NODE | head -1 | awk '{print $5}'` # optionally hardcode public ip
PUBLIC_IPS=$PUBLIC_IP
INITIAL_CLUSTER="${NODE_NAME}=http://${PUBLIC_IP}:2380"

for n in $NODESET; do
    if [ "$n" != "$NODE" ]; then
        # find public ip of other node and add it to cluster
        ip=`ping -c 1 $n | head -1 | awk '{print $3}' | tr -d '()'`
        cn="${PRE}${n}=http://${ip}:2380"
        echo "Adding ${cn} to cluster"
        INITIAL_CLUSTER="${INITIAL_CLUSTER},${cn}"
        PUBLIC_IPS="${PUBLIC_IPS},${ip}"
    fi
done

echo "Running etcd cluster, local node address is $PUBLIC_IP"
echo "IPs: $PUBLIC_IPS"
echo "Cluster: $INITIAL_CLUSTER"

if [ -n "$PUBLIC_IP" ]; then
    docker ps -a | grep $CONTAINER_NAME | grep Exited | cut -c -12 | xargs --no-run-if-empty docker rm
    docker run --name $CONTAINER_NAME -p 4001:4001 -p 2380:2380 -p 2379:2379 pfrandsen/etcd:v1 \
    etcd -name ${NODE_NAME} \
      -initial-advertise-peer-urls http://${PUBLIC_IP}:2380 \
      -listen-peer-urls http://0.0.0.0:2380 \
      -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
      -advertise-client-urls http://${PUBLIC_IP}:2379 \
      -initial-cluster-token etcd-cluster-1 \
      -initial-cluster $INITIAL_CLUSTER \
      -initial-cluster-state new
else
    echo "Error: ip not found"
fi

