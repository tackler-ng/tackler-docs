git init --bare acme-hq.git
git clone acme-hq.git/

cd acme-hq
mkdir conf
git config user.name "ACME HQ"
git config user.email "hq@acme"

git commit -m init --allow-empty
git push
