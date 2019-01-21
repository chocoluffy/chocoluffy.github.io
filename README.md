[![Build Status](https://travis-ci.org/chocoluffy/chocoluffy.github.io.svg?branch=master)](https://travis-ci.org/chocoluffy/chocoluffy.github.io)

# Deploy

`git push origin hexo:hexo`

# Follow-up

- After Travis CI finished pushing master branch every time upload a new post. At local master branch `git checkout master`, pull the master branch and run `sh submit-to-baidu.sh` to submit latest blog posts to baidu crawler. Remember to input token from baidu.

# Common Error

### [19.1.20] Cloudflare
强制Https，以及选择Auto Minify HTML。

### [19.1.18] Leancloud SDK
由于https://cdn1.lncld.net/static/js/av-core-mini-0.6.1.js 在国外无法访问，我安装了hola vpn指定在浏览器内我的博客通过国内的IP来访问。现在修改source为私人源 https://chocoluffy.com/toolbox/hexo/av-core-mini-0.6.1.js。

### [18.12.21] package.json锁定版本
Due to some modules' version update. need to find the latest compatible version and lock them. (尤其是hexo-douban)，在package.json里指定版本，防止小版本升级引入breaking changes。

### [18.12.15] hexo-douban自定义, 覆盖原node_modules的文件
在`.travis.yml`里面。可以通过覆盖原node_modules的文件来达到更新lib文件的目的。曾经试过因为豆瓣书太多导致query速度慢而`timout`，可以在`books-generator.js`里面把tineout调整为25000（25秒）来恢复。同时因为我也需要自定义这个页面的样式，所以我用自己的`book.ejs`来覆盖原有的文件。
```
script:
    - yes | cp book/book.ejs node_modules/hexo-douban/lib/templates
    - yes | cp book/books-generator.js node_modules/hexo-douban/lib
    - hexo clean
    - hexo g
    - hexo douban
```

### [18.12.1] 自定义node_modules
在github上fork，然后添加改动之后，在package.json里面引用.git的链接。
- [node.js - How to edit a node module installed via npm? - Stack Overflow](https://stackoverflow.com/questions/13300137/how-to-edit-a-node-module-installed-via-npm)
- [node.js - How to edit a node module installed via npm? - Stack Overflow](https://stackoverflow.com/questions/13300137/how-to-edit-a-node-module-installed-via-npm)
比如 `https://github.com/chocoluffy/hexo-footnotes/tarball/master`

### 添加footnote
- [GitHub - LouisBarranqueiro/hexo-footnotes: A plugin to support markdown footnotes in your Hexo blog posts](https://github.com/LouisBarranqueiro/hexo-footnotes)
添加`[^1]`即可。