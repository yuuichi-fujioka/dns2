#!/bin/bash -e

for n in $(docker-compose exec etcd etcdctl ls -r | tac); do
    n=$(echo $n | tr -d '\r')
    dir=$(dirname $n)
    echo $n
    [ -d "./dumps$dir" ] || mkdir -p "./dumps$dir"
    [ -d "./dumps$n" ] || docker-compose exec etcd etcdctl get $n > ./dumps$n
done
