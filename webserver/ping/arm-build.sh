#!/bin/bash

# Requires Go > 1.5 for cross compilation

export GOOS=linux
export GOARCH=arm
export GOARM=7

rm -f server
echo "Cross compiling sample webserver for $GOOS $GOARCH $GOARM"
go build server.go
