#!/bin/bash

NODE=`hostname`
NODE_NAME="etcd-$NODE"
CONTAINER_NAME="etcd-${NODE}-container"

# cannot use the following as Snappy does not have host command
# PUBLIC_IP=`host -t a $NODE | awk '{print $4}' | egrep ^[1-9]`
PUBLIC_IP=`ping -c 1 -I eth0 -W 1 $NODE | head -1 | awk '{print $5}'` # optionally hardcode public ip

echo "Running etcd, ip is $PUBLIC_IP"

if [ -n "$PUBLIC_IP" ]; then
    docker run --name $CONTAINER_NAME -p 4001:4001 -p 2380:2380 -p 2379:2379 pfrandsen/etcd:v1 \
    etcd -name $NODE_NAME \
      -advertise-client-urls http://${PUBLIC_IP}:2379,http://${PUBLIC_IP}:4001 \
      -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
      -initial-advertise-peer-urls http://${PUBLIC_IP}:2380 \
      -listen-peer-urls http://0.0.0.0:2380 \
      -initial-cluster-token etcd-cluster-1 \
      -initial-cluster $NODE_NAME=http://${PUBLIC_IP}:2380 \
      -initial-cluster-state new
else
    echo "Error: ip not found"
fi

