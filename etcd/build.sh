#!/bin/bash

# Requires Go > 1.5 for cross compilation

ARM=false
SRC_DIR=src
ETCD_VERSION=2.2.2 # See https://github.com/coreos/etcd/releases/ for the latest release
USAGE_SHORT="[-v=$ETCD_VERSION] [-d=$SRC_DIR] [-a]"
USAGE_LONG="[--version=$ETCD_VERSION] [--directory=$SRC_DIR] [--arm]"

# handle script arguments
for i in "$@"
do
case $i in
    -h|--help)
    echo "usage: $0 $USAGE_SHORT"
    echo "usage: $0 $USAGE_LONG"
    echo -e "\nall arguments are optional"
    echo "default values for source version and target directory are shown above"
    echo "if arm flag is present the source will be cross compiled for ARM architecture"
    exit 0
    ;;
    -v=*|--version=*)
    ETCD_VERSION="${i#*=}"
    ;;
    -d=*|--directory=*)
    SRC_DIR="${i#*=}"
    ;;
    -a|--arm)
    ARM=true
    ;;
    *)
            # unknown option
    ;;
esac
done

if [ -d "$SRC_DIR" ]; then
    echo "Error: Source directory '$SRC_DIR' already exists"  >&2
    exit 1
fi

if [ "$ARM" = "true" ]
then
  export GOOS=linux
  export GOARCH=arm
  export GOARM=7
  echo "cross compiling etcd $ETCD_VERSION for $GOOS $GOARCH $GOARM"
else
  echo "compiling etcd $ETCD_VERSION for default OS and architecture"
fi

mkdir $SRC_DIR
echo "fetching etcd source and unpacking in $SRC_DIR directory"
curl -sSL -k https://github.com/coreos/etcd/archive/v${ETCD_VERSION}.tar.gz | tar --touch --directory $SRC_DIR -xz
pushd $SRC_DIR/etcd-${ETCD_VERSION} > /dev/null 2>&1

# etcd build script likes to have the source in a git repo in order to generate sha hash (git rev-parse --short HEAD)
echo "converting "`pwd`" to git repo"
git init > /dev/null 2>&1
git add . > /dev/null 2>&1
git commit -m "etcd ${ETCD_VERSION} source" > /dev/null 2>&1
echo "building etcd and etcdclt ..."
./build
echo "binaries can be found in "`pwd`"/bin"
popd > /dev/null 2>&1

