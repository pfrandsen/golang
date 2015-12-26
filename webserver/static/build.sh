#!/bin/bash

rm -f static
echo "Compiling static files webserver"
go build static.go
