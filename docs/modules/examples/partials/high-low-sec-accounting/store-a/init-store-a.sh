git init --bare acme-store-A.git
git clone acme-store-A.git/
cd acme-store-A
mkdir -p txns/store-a
git commit -m init --allow-empty
git push
