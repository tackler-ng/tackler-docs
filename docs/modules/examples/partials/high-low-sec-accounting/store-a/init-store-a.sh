git init --bare store-a.git
git clone store-a.git/

cd store-a
mkdir -p txns/store-a

git config user.name "ACME Store A"
git config user.email "store-a@acme"

git commit -m init --allow-empty
git push
