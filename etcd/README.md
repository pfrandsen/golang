#etcd#

### build.sh
Script for building etcd Go source. Including cross compilation for ARM architecture.

Run ./build.sh --help for usage information

### run-single.sh
Script for running etcd service on single node with network access

If run-single.sh is run on a host named **node-1** key-value pairs can be written and read from other hosts on the network as shown in the examples below:

1. Write: curl -L http://node-1:2379/v2/keys/mykey -XPUT -d value="its alive"
2. Read: curl -L http://node-1:2379/v2/keys/mykey
