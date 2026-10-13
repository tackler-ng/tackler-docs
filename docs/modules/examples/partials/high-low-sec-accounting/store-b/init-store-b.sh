git init --bare acme-store-B.git/
git clone  acme-store-B.git/

cd acme-store-B
mkdir -p txns/store-b

git config user.name "ACME Store B"
git config user.email "store-b@acme"

git commit -m init --allow-empty
git push
