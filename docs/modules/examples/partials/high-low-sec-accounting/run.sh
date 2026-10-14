#!/bin/sh
# vim: tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab autoindent

set -e

exe_dir=$(dirname $(realpath $0))

mkdir acme-inc
cd acme-inc

(
    sh $exe_dir/hq/init.sh \
        $exe_dir/hq/conf/hq-conf.toml \
        $exe_dir/hq/conf/hq-accounts.toml \
        $exe_dir/hq/conf/hq-commodities.toml \
        $exe_dir/hq/conf/hq-tags.toml
)
sleep 1

(
    sh $exe_dir/store-a/init.sh \
        $exe_dir/store-a/conf/store-a-conf.toml \
        $exe_dir/store-a/conf/store-a-accounts.toml \
        $exe_dir/store-a/conf/store-a-commodities.toml \
        $exe_dir/store-a/conf/store-a-tags.toml
)
sleep 1

(
    sh $exe_dir/store-b/init.sh
)
sleep 1

(
    cd hq
    sh $exe_dir/hq/remotes.sh
)

(
    cd store-a
    sh $exe_dir/store-a/sales.sh \
        "001" $exe_dir/store-a/sales-001.txn
)
sleep 1

(
    cd store-b
    sh $exe_dir/store-b/sales.sh \
        "001" $exe_dir/store-b/sales-001.txn
)
sleep 1


(
    cd hq
    sh $exe_dir/hq/update.sh
    sh $exe_dir/hq/report.sh
)
sleep 1

(
    cd store-b
    sh $exe_dir/store-b/sales.sh \
        "002" $exe_dir/store-b/sales-002.txn
)
sleep 1

(
	cd store-b
	sh $exe_dir/store-b/sales.sh \
	"003" $exe_dir/store-b/sales-003.txn
)
sleep 1

(
    cd hq
    sh $exe_dir/hq/update.sh
    sh $exe_dir/hq/report.sh
)
sleep 1

(
    cd store-a
    sh $exe_dir/store-a/sales.sh \
        "002" $exe_dir/store-a/sales-002.txn
)
sleep 1

(
    cd hq
    sh $exe_dir/hq/update.sh
    sh $exe_dir/hq/report.sh
)

(
    cd hq
    sh $exe_dir/hq/filter.sh
)

(
    cd store-a
    sh $exe_dir/store-a/report.sh
)


