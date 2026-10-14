#!/bin/sh

set -e

exe_dir=$(dirname $(realpath $0))

mkdir acme-inc
cd acme-inc

(sh $exe_dir/hq/init-hq.sh)
cp  $exe_dir/hq/conf/hq-conf.toml hq/conf/
cp  $exe_dir/hq/conf/hq-accounts.toml hq/conf/
cp  $exe_dir/hq/conf/hq-commodities.toml hq/conf/

sleep 1

(sh $exe_dir/store-a/init-store-a.sh)
sleep 1

(sh $exe_dir/store-b/init-store-b.sh)
sleep 1

(sh $exe_dir/hq/hq-remotes.sh)

cp  $exe_dir/store-a/sales-001.txn store-a/txns/store-a/
(sh $exe_dir/store-a/sales-001.sh)

cp  $exe_dir/store-b/sales-001.txn store-b/txns/store-b/
(sh $exe_dir/store-b/sales-001.sh)


(sh $exe_dir/hq/hq-accounting-01.sh)
sleep 1

cp  $exe_dir/store-b/sales-002.txn store-b/txns/store-b/
(sh $exe_dir/store-b/sales-002.sh)

cp  $exe_dir/store-b/sales-003.txn store-b/txns/store-b/
(sh $exe_dir/store-b/sales-003.sh)

(sh $exe_dir/hq/hq-accounting-02.sh)
sleep 1

cp  $exe_dir/store-a/sales-002.txn store-a/txns/store-a/
(sh $exe_dir/store-a/sales-002.sh)

(sh $exe_dir/hq/hq-accounting-03.sh)
