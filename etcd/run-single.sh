#!/bin/bash

# use hostname in advertise client urls
NODE_NAME="etcd-"`hostname`
LCU="http://0.0.0.0:2379,http://0.0.0.0:4001"
ACU="http://"`hostname`":2379,http://"`hostname`":4001"
./etcd -name $NODE_NAME -listen-client-urls $LCU -advertise-client-urls $ACU

