# local dns

## How to Use

Requires:

* docker-compose

```
$ git clone https://github.com/yuuichi-fujioka/dns2
$ cd dns2
$ docker-compose up -d
```

## Set DNS Recoad

See: https://github.com/skynetservices/skydns

* `192.168.0.101 foo.example.com`

Set:

```
docker-compose exec etcd etcdctl set /dns/com/example/foo '{"host": "192.168.0.101"}'
```

Test:

```
$ dig -p 1053 @localhost foo.example.com +noall +answer
; <<>> DiG 9.10.3-P4-Ubuntu <<>> -p 1053 @localhost foo.example.com +noall +answer
; (2 servers found)
;; global options: +cmd
foo.example.com.	300	IN	A	192.168.0.101
```

* CNAME `bar.example.com`

Set:

```
docker-compose exec etcd etcdctl set /dns/com/example/foo '{"host": "192.168.0.101"}'
docker-compose exec etcd etcdctl set /dns/com/example/bar '{"host": "foo.example.com"}'
```

Test:

```
$ dig -p 1053 @localhost bar.example.com +noall +answer
; <<>> DiG 9.10.3-P4-Ubuntu <<>> -p 1053 @localhost bar.example.com +noall +answer
; (2 servers found)
;; global options: +cmd
bar.example.com.	300	IN	CNAME	foo.example.com.
foo.example.com.	300	IN	A	192.168.0.101
```

* DNS Round Robin `baz.example.com`

Set:

```
docker-compose exec etcd etcdctl set /dns/com/example/baz/1 '{"host": "192.168.0.101"}'
docker-compose exec etcd etcdctl set /dns/com/example/baz/2 '{"host": "192.168.0.102"}'
```

Test:

```
$ dig -p 1053 @localhost baz.example.com +noall +answer
; <<>> DiG 9.10.3-P4-Ubuntu <<>> -p 1053 @localhost baz.example.com +noall +answer
; (2 servers found)
;; global options: +cmd
baz.example.com.	300	IN	A	192.168.0.101
baz.example.com.	300	IN	A	192.168.0.102

$ dig -p 1053 @localhost baz.example.com +noall +answer
; <<>> DiG 9.10.3-P4-Ubuntu <<>> -p 1053 @localhost baz.example.com +noall +answer
; (2 servers found)
;; global options: +cmd
baz.example.com.	300	IN	A	192.168.0.102
baz.example.com.	300	IN	A	192.168.0.101

$ dig -p 1053 @localhost baz.example.com +noall +answer
; <<>> DiG 9.10.3-P4-Ubuntu <<>> -p 1053 @localhost baz.example.com +noall +answer
; (2 servers found)
;; global options: +cmd
baz.example.com.	300	IN	A	192.168.0.101
baz.example.com.	300	IN	A	192.168.0.102
```
