#!/bin/bash
set -ev

# Ensure public directory exists
if [ ! -d "./public" ]; then
    echo "Public directory doesn't exist. Creating it."
    mkdir -p ./public
fi

# get clone master
git clone https://${GH_REF} .deploy_git
cd .deploy_git
git checkout master

cd ../
mv .deploy_git/.git/ ./public/

cd ./public

git config user.name "chocoluffy"
git config user.email "luffy.yu@mail.utoronto.ca"

# add commit timestamp
git add .
git commit -m "Travis CI Auto Builder at `date +"%Y-%m-%d %H:%M"`"

git push --force --quiet "https://${TravisCI_Token}@${GH_REF}" master:master