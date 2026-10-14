git init --bare hq.git
git clone hq.git/

cd hq
mkdir conf
git config user.name "ACME HQ"
git config user.email "hq@acme"

git commit -m init --allow-empty
git push
