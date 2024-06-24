#!/bin/bash
set -ev

# Debug: Print current directory and its contents
echo "Current directory: $(pwd)"
ls -la

# Debug: Check public directory contents
echo "Contents of public directory:"
ls -la ./public

# get clone master
git clone https://${GH_REF} .deploy_git
cd .deploy_git
git checkout master
cd ../

mv .deploy_git/.git/ ./public

cd ./public

git config user.name "chocoluffy"
git config user.email "luffy.yu@mail.utoronto.ca"

# add commit timestamp
git add .
git commit -m "Travis CI Auto Builder at `date +"%Y-%m-%d %H:%M"`"

# git push --force --quiet "https://${TravisCI_Token}@${GH_REF}" master:master
# 240624 Update Github Push.
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:master