#!/bin/sh
# vim: tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab autoindent

set -e

exe_dir=$(dirname $(realpath $0))

rm -f $exe_dir/reports/*.txt

mkdir acme-inc
cd acme-inc

echo
echo "#################################################"
echo "### Init HQ" 
echo "#################################################"
(
    ts="2024-12-01T10:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/hq/init.sh \
        $exe_dir/hq/conf/hq-conf.toml \
        $exe_dir/hq/conf/hq-accounts.toml \
        $exe_dir/hq/conf/hq-commodities.toml \
        $exe_dir/hq/conf/hq-tags.toml
)

echo
echo "#################################################"
echo "Init Store A" 
echo "#################################################"
(
    ts="2024-12-01T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-a/init.sh \
        $exe_dir/store-a/conf/store-a-conf.toml \
        $exe_dir/store-a/conf/store-a-accounts.toml \
        $exe_dir/store-a/conf/store-a-commodities.toml \
        $exe_dir/store-a/conf/store-a-tags.toml
)

echo
echo "#################################################"
echo "Init Store B" 
echo "#################################################"
(
    ts="2024-12-01T14:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-b/init.sh
)

echo
echo "#################################################"
echo "Setup connection between HQ and stores" 
echo "#################################################"
(
    cd hq
    sh $exe_dir/hq/remotes.sh
)

echo
echo "#################################################"
echo "Store A: sales #001" 
echo "#################################################"
(
    cd store-a
    ts="2024-12-17T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-a/sales.sh \
        "001" $exe_dir/store-a/sales-001.txn
)

echo
echo "#################################################"
echo "Store B: sales #001" 
echo "#################################################"
(
    cd store-b
    ts="2024-12-17T14:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-b/sales.sh \
        "001" $exe_dir/store-b/sales-001.txn
)

echo
echo "#################################################"
echo "HQ: Syncronize journals and report" 
echo "#################################################"
(
    cd hq
    ts="2024-12-17T16:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/hq/update.sh

    sh $exe_dir/hq/report.sh \
        --output.dir $exe_dir/reports \
        --output.prefix hq-begin
)

echo
echo "#################################################"
echo "Store B: sales #002" 
echo "#################################################"
(
    cd store-b
    ts="2024-12-18T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-b/sales.sh \
        "002" $exe_dir/store-b/sales-002.txn
)

echo
echo "#################################################"
echo "Store B: sales #003" 
echo "#################################################"
(
	cd store-b
    ts="2024-12-19T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
	sh $exe_dir/store-b/sales.sh \
        "003" $exe_dir/store-b/sales-003.txn
)

echo
echo "#################################################"
echo "Store A: sales #002" 
echo "#################################################"
(
    cd store-a
    ts="2024-12-20T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-a/sales.sh \
        "002" $exe_dir/store-a/sales-002.txn
)

echo
echo "#################################################"
echo "HQ: Syncronize journals and report" 
echo "#################################################"
(
    cd hq
    ts="2024-12-20T16:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/hq/update.sh

    sh $exe_dir/hq/report.sh \
        --output.dir $exe_dir/reports \
        --output.prefix hq-final
)

echo
echo "#################################################"
echo "HQ: Report only Store A" 
echo "#################################################"
(
    cd hq
    sh $exe_dir/hq/filter.sh \
        --output.dir $exe_dir/reports \
        --output.prefix hq-filter
)

echo
echo "#################################################"
echo "Store A: Report" 
echo "#################################################"
(
    cd store-a
    sh $exe_dir/store-a/report.sh \
        --output.dir $exe_dir/reports \
        --output.prefix store-a
)
