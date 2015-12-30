#!/bin/bash

# remove all containers that have exited
docker ps -a | grep Exited | cut -c -12 | xargs --no-run-if-empty docker rm
