git init --bare hq.git
git clone hq.git/

cd hq
git config user.name "ACME HQ"
git config user.email "hq@acme"
git commit -m init --allow-empty

mkdir conf
cp "$@" conf/

git add conf
git commit -m "HQ conf"
git push
