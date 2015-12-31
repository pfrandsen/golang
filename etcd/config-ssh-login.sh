#!/bin/bash

DEVICENAMES="node-1 node-2 node-3 node-4"
echo "type <enter> to each question (y for overwrite)"
ssh-keygen -t rsa
ssh-add
for device in $DEVICENAMES; do
    ssh-copy-id ubuntu@$device
done
