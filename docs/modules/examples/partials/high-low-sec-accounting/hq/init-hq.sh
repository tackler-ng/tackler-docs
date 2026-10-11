mkdir acme-inc; cd acme-inc

git init --bare acme-hq.git
git clone acme-hq.git/
cd acme-hq
git commit -m init --allow-empty
git push
