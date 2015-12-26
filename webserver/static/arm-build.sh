#!/bin/bash

# Requires Go > 1.5 for cross compilation

export GOOS=linux
export GOARCH=arm
export GOARM=7

rm -f static
echo "Cross compiling static files webserver for $GOOS $GOARCH $GOARM"
go build static.go
