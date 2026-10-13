git init --bare acme-store-A.git
git clone acme-store-A.git/

cd acme-store-A
mkdir -p txns/store-a

git config user.name "ACME Store A"
git config user.email "store-a@acme"

git commit -m init --allow-empty
git push
