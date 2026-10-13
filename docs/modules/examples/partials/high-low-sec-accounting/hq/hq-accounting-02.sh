cd acme-hq

git remote update -p
git merge --allow-unrelated-histories -m "hq: merge store B again" store-b/main

tackler --config conf/hq-conf.toml
