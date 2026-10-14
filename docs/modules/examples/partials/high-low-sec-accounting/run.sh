#!/bin/sh
# vim: tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab autoindent

set -e

exe_dir=$(dirname $(realpath $0))

rm -f $exe_dir/reports/*.txt

mkdir acme-inc
cd acme-inc

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

(
    ts="2024-12-01T14:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-b/init.sh
)

(
    cd hq
    sh $exe_dir/hq/remotes.sh
)

(
    cd store-a
    ts="2024-12-17T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-a/sales.sh \
        "001" $exe_dir/store-a/sales-001.txn
)

(
    cd store-b
    ts="2024-12-17T14:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-b/sales.sh \
        "001" $exe_dir/store-b/sales-001.txn
)

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

(
    cd store-b
    ts="2024-12-18T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-b/sales.sh \
        "002" $exe_dir/store-b/sales-002.txn
)

(
	cd store-b
    ts="2024-12-19T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
	sh $exe_dir/store-b/sales.sh \
        "003" $exe_dir/store-b/sales-003.txn
)

#(
#    cd hq
#    ts="2024-12-19T16:00:00+0000"
#    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
#    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
#    sh $exe_dir/hq/update.sh
#
#    sh $exe_dir/hq/report.sh
#)

(
    cd store-a
    ts="2024-12-20T12:00:00+0000"
    GIT_AUTHOR_DATE="$ts" GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    sh $exe_dir/store-a/sales.sh \
        "002" $exe_dir/store-a/sales-002.txn
)

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

(
    cd hq
    sh $exe_dir/hq/filter.sh \
        --output.dir $exe_dir/reports \
        --output.prefix hq-filter
)

(
    cd store-a
    sh $exe_dir/store-a/report.sh \
        --output.dir $exe_dir/reports \
        --output.prefix store-a
)
