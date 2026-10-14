cd hq

git remote update -p
git merge --allow-unrelated-histories -m "hq: merge store A again" store-a/main

tackler --config conf/hq-conf.toml
