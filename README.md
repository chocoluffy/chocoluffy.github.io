[![Build Status](https://travis-ci.org/chocoluffy/chocoluffy.github.io.svg?branch=master)](https://travis-ci.org/chocoluffy/chocoluffy.github.io)

# Deploy

`git push origin hexo:hexo`

# Follow-up

- After Travis CI finished pushing master branch every time upload a new post. At local master branch `git checkout master`, pull the master branch and run `sh submit-to-baidu.sh` to submit latest blog posts to baidu crawler. Remember to input token from baidu.

# Common Error

- Due to some modules' version update. need to find the latest compatible version and lock them. 