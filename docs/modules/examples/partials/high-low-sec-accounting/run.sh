#!/bin/sh

exe_dir=$(dirname $(realpath $0))

mkdir acme-inc
cd acme-inc

(sh $exe_dir/hq/init-hq.sh)
cp  $exe_dir/hq/conf/hq-conf.toml acme-hq/conf/

sleep 2

(sh $exe_dir/store-a/init-store-a.sh)
sleep 2

(sh $exe_dir/store-b/init-store-b.sh)
sleep 2

(sh $exe_dir/hq/hq-remotes.sh)

cp  $exe_dir/store-a/sales-001.txn acme-store-A/txns/store-a/
(sh $exe_dir/store-a/sales-001.sh)

cp  $exe_dir/store-b/sales-001.txn acme-store-B/txns/store-b/
(sh $exe_dir/store-b/sales-001.sh)


(sh $exe_dir/hq/hq-accounting-01.sh)


cp  $exe_dir/store-b/sales-002.txn acme-store-B/txns/store-b/
(sh $exe_dir/store-b/sales-002.sh)


cp  $exe_dir/store-b/sales-003.txn acme-store-B/txns/store-b/
(sh $exe_dir/store-b/sales-003.sh)

(sh $exe_dir/hq/hq-accounting-02.sh)

