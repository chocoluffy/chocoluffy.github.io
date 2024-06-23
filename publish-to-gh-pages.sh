#!/bin/bash
set -ev

# Check if public directory exists and is a directory
if [ ! -d "./public" ]; then
    echo "Error: public directory not found. Make sure 'hexo g' completed successfully."
    exit 1
fi

# Debug: Check public directory contents
echo "Contents of public directory:"
ls -la ./public

# get clone master
git clone https://${GH_REF} .deploy_git
cd .deploy_git
git checkout master
cd ../

# Debug: Print current directory and its contents
echo "Current directory: $(pwd)"
ls -la

mv .deploy_git/.git/ ./public

cd ./public

git config user.name "chocoluffy"
git config user.email "luffy.yu@mail.utoronto.ca"

# add commit timestamp
git add .
git commit -m "Travis CI Auto Builder at `date +"%Y-%m-%d %H:%M"`"

git push --force --quiet "https://${TravisCI_Token}@${GH_REF}" master:master