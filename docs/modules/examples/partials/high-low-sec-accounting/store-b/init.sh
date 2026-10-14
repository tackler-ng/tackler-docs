git init --bare store-b.git/
git clone store-b.git/

cd store-b
mkdir -p txns/store-b

git config user.name "ACME Store B"
git config user.email "store-b@acme"

git commit -m init --allow-empty
git push
