#!/bin/bash

rm -f server
echo "Compiling sample webserver"
go build server.go
