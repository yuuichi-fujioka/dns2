#!/bin/bash


docker-compose exec etcd etcdctl set /dns/com/example/foo '{"host": "192.168.0.101"}'

dig -p 53 @localhost foo.example.com +noall +answer

docker-compose exec etcd etcdctl set /dns/com/example/foo '{"host": "192.168.0.101"}'
docker-compose exec etcd etcdctl set /dns/com/example/bar '{"host": "foo.example.com"}'

dig -p 53 @localhost bar.example.com +noall +answer

docker-compose exec etcd etcdctl set /dns/com/example/baz/1 '{"host": "192.168.0.101"}'
docker-compose exec etcd etcdctl set /dns/com/example/baz/2 '{"host": "192.168.0.102"}'

dig -p 53 @localhost baz.example.com +noall +answer
dig -p 53 @localhost baz.example.com +noall +answer
dig -p 53 @localhost baz.example.com +noall +answer
