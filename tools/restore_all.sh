#!/bin/bash

(
cd dumps
for n in $(find . -type f); do
    docker-compose exec etcd etcdctl set $n "$(cat $n)"
done
)
