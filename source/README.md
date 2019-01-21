[![Build Status](https://travis-ci.org/chocoluffy/chocoluffy.github.io.svg?branch=master)](https://travis-ci.org/chocoluffy/chocoluffy.github.io)

# Deploy

`git push origin hexo:hexo`

# Follow-up

- After Travis CI finished pushing master branch every time upload a new post. At local master branch `git checkout master`, pull the master branch and run `sh submit-to-baidu.sh` to submit latest blog posts to baidu crawler. Remember to input token from baidu.

# Common Error

- Due to some modules' version update. need to find the latest compatible version and lock them.
- [19.1.18]leancloud SDK 评论API，由于https://cdn1.lncld.net/static/js/av-core-mini-0.6.1.js 在国外无法访问，我安装了hola vpn指定在浏览器内我的博客通过国内的IP来访问。现在修改source为私人源 https://chocoluffy.com/toolbox/hexo/av-core-mini-0.6.1.js。