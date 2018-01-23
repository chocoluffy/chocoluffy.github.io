title: 关于hexo博客最棒的素材和教程收集
date: 2015-12-25 11:29:20
tags: [hexo]
categories: 技术
---

在搭建hexo博客的时候遇到的各种坑， 留下一些最棒的博文和大家分享!

<!-- more -->

## 常用功能

### 添加豆瓣读书插件

> 每一次如果`hexo g`会报错，通常都是因为我系统的node的版本不对；需要用`nvm use system`来改成node 4.5来运行操作。

[GitHub - ForbesLindesay/sync-request: Make synchronous web requests with cross platform support.](https://github.com/ForbesLindesay/sync-request) 用sync-request来修改hexo-douban，实现爬去书籍消息的功能。

demo: https://blog.mythsman.com/books/

开发的组件博客 https://blog.mythsman.com/
github： [hexo-douban/book.ejs at master · mythsman/hexo-douban · GitHub](https://github.com/mythsman/hexo-douban/blob/master/lib/templates/book.ejs)

类似的但是样式上差一点的另一个组件 [GitHub - Yikun/hexo-generator-douban: Douban page generator plugin for Hexo.](https://github.com/Yikun/hexo-generator-douban)

### 添加微博组件

[在Hexo博客中添加微博秀 | The Bloom of Youth | 锦瑟华年](http://kuangqi.me/tricks/add-weibo-show-in-hexo/)

[Hexo有用的工具和插件汇总 | suarezzz’s blog](https://suarezzz.github.io/2016/07/02/hexo-useful-tools/)


### 怎样使用七牛云服务来存储静态资源

- [1][Linux中国采用“七牛”云存储支撑图片访问](https://linux.cn/article-2311-1.html)
- [2][使用七牛CDN加速博客静态文件访问](https://blog.blahgeek.com/qiniu-cdn-serve-static/)

个人的话， 我其实用的是微博图床， 也很方便。 类似的服务还有dropbox, google drive等等。

Edit: 16.3.12更新， 现在我自己通过自己写的scripts来自动化将博文中的image上传的任务了， 所有的图片都将上传到leancloud然后得到一个external url可以在md博客中直接展示， 这样做更加的自动化和节省我的时间!! 具体操作方法看下面的介绍。

### 关于hexo _config文件的配置细节

推荐博文：

- [hexo你的博客](http://ibruce.info/2013/11/22/hexo-your-blog/)
- [给hexo添加disqus的评论框](https://gist.github.com/mabrasil/dc245da48a757b91b777)
- [给hexo博文添加访问次数统计-不蒜子统计](http://ibruce.info/2013/12/22/count-views-of-hexo/)

### 关于hexo基础的command
```
hexo new "article name"
hexo new page "about" # 给blog添加一个新的main entry endpoint. 比如/about等
hexo generate
hexo deploy
```
可以利用这个`hexo new page "about"`这个想法来收集很多的放在collection里面的东西， 比如自己的photography, 自己的bookreview等等， 就是那些不适合放在单独的博客文章中的东西， 都可以尝试整理在这里面， 然后在一个portal里面留下入口， 比如在"/life"里面留下我的"/photography"和"/bookreview"等等， 这样会更加的organized。

### 在hexo博客里面内嵌html静态网页

我们有将静态网页展示出来作为example的需求， 尤其是在介绍新技术的时候，首先将该静态网站部署在服务器上， 无论是github上利用gh-pages的静态前端网页， 还是elastic beanstalk的后端serve的前端(利用express的`app.use(express.static(__dirname + '/public'));`可以将public文件夹下面的html文件都serve出来!!!!)， 这么做的好处是我们可以得到external URL， 可以将这个URL插入在iframe里面， 然后在md文章里面直接使用!!!! 比如下面这个例子亲测成功， 注意就是要将插入的网页居中就是了!!

```html
<div style='text-align:center' markdown='1'>
	<iframe src="https://mdn-samples.mozilla.org/snippets/html/iframe-simple-contents.html" width="100%" height="400">
		<p>Your browser does not support iframes.</p>
	</iframe>
</div>
```

### 居中文本\图片样式

具体效果参考[这篇博文](http://chocoluffy.com/2015/03/30/%E4%BC%AF%E5%85%8B%E5%88%A9%E7%9A%84%E7%A7%98%E5%AF%86-%E4%B8%8A-%E6%A2%A6%E6%83%B3%E7%9A%84%E7%81%AB%E5%85%89/)的样式， 其中在第一段添加了居中文本作为开头。 特别适合在段落间插入， 作为章节的小结， 很优雅~

![blockquote](http://ac-TC2Vc5Tu.clouddn.com/c215777fa66e5464.png)

使用方法`<blockquote class="blockquote-center">blah blah blah</blockquote>`

将图片居中方法`<img src="http://ac-TC2Vc5Tu.clouddn.com/6ceefbf6929babac.png" style="display: block; margin: 0 auto;">`， 直接添加inline styling， 在markdown中插入html image tag。

将图片突破通常边际大小的样式`<img src="/image-url" class="full-image" />`。

### 关于怎样自动化博文图片上传

参考[自动化替换 Markdown 中的本地图片引用](http://laobie.github.io/python/2016/04/24/replace-image-file-in-markdown.html)。 我已经在我的.zshrc文件里面配置好了， 之后写一些多图的博客文章的时候， 可以先放一个`img/demo.jpg`这样的路径占位， 之后在从quiver export出md文件后在那个文件夹目录下创建img文件夹和要用的图片执行`lzmd source.md target.md`即可。[github链接](https://github.com/chocoluffy/lazy-markdown)

参考[将markdown文章中的图片居中](http://www.denizoguz.com/2013/08/07/how-to-align-images-in-markdown/)。 还需要做的事是， 把这个做法加入到lzmd的scripts里面， 做到一起的自动化。[github链接](https://github.com/chocoluffy/lazy-screen-capture)

```python
def replace_img(source_md, target_md, conn):
    image_list = get_image_list_from_md(source_md)
    md_content = open(source_md).read()
    fb = open(target_md, 'w')

    print 'start >>>>>\n'

    for image in image_list:
        source_img = os.path.join(os.path.split(source_md)[0], image[1])
        if not os.path.exists(source_img):
            continue

        db_data = find_in_db(conn, calc_hash(source_img))
        if db_data:
            print("[%s] >>> url: %s" % (os.path.split(source_img)[1], db_data[1]))
            url = db_data[1]
            // 重点在添加一个子元素align的div wrapper
            md_content = md_content.replace(image[0], "<div style='text-align:center' markdown='1'>" + image[0].replace(image[1], str(url)) + "</div>")

        elif os.path.isfile(source_img):
            compressed_img = os.path.join(os.path.split(source_img)[0], 'cp_' + os.path.split(source_img)[1])
            compress(source_img, compressed_img)
            url = upload(compressed_img)
            // 重点在添加一个子元素align的div wrapper
            md_content = md_content.replace(image[0], "<div style='text-align:center' markdown='1'>" + image[0].replace(image[1], str(url)) + "</div>")
            write_db(conn, calc_hash(source_img), url)

        else:
            print source_img + "is not exit or not a file"

    print '\n<<<<< end'

    fb.write(md_content)
    fb.close()
```


## Further Reading (more useful links)

- [github markdown css standard](https://gist.github.com/andyferra/2554919) 如果希望自己tweak一下自己博客的样式， 尤其是markdown渲染出来的效果， 可以参考下github的markdown样式， 我就自己对着修改了一些

- [添加styling for html list(ordered or unordered)](http://designshack.net/articles/css/5-simple-and-practical-css-list-styles-you-can-copy-and-paste/)

- [hexo next主题官方配置文档](http://theme-next.iissnan.com/getting-started.html)

- [Simple and nice blockquote styling](https://css-tricks.com/snippets/css/simple-and-nice-blockquote-styling/) 

- [Build A Blog With Jekyll And GitHub Pages](http://www.smashingmagazine.com/2014/08/build-blog-jekyll-github-pages/)

- [更换另一个hexo主题](http://jinyanhuan.github.io/2015/03/16/hexo-bulid-three/)

- [搭建一个免费的，无限流量的Blog----github Pages和Jekyll入门](http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html)

- [给Hexo博客添加站内搜索](http://www.jerryfu.net/post/search-engine-for-hexo-with-swiftype.html)

- [在Hexo博文里面添加音乐\gif\视频等的教程](http://starsky.gitcafe.io/2015/05/05/Hexo%E6%B7%BB%E5%8A%A0%E5%9B%BE%E7%89%87%E3%80%81%E9%9F%B3%E4%B9%90%E5%92%8C%E8%A7%86%E9%A2%91/)

- [私人定制hexo主题，添加横幅logo](http://blog.sunnyxx.com/2014/03/07/hexo_customize/)

- [A plugin for Hexo that optimizes HTML, CSS, JS and images(Minify)](https://github.com/unhealthy/hexo-all-minifier)

- [给Hexo网站添加sitemap和robots.txt](http://www.jeyzhang.com/hexo-website-seo.html)

- [给Hexo网站添加meta tag提高SEO](https://moral.im/%E4%B8%BAHexo%E6%B7%BB%E5%8A%A0meta%20Keyword/)

	- [去goole search console管理property](https://www.google.com/webmasters/tools/home?hl=en&authuser=0)

	- [google search console sitemap dashboard](https://www.google.com/webmasters/tools/sitemap-list?hl=en&authuser=0&siteUrl=http%3A%2F%2Fchocoluffy.com%2F#MAIN_TAB=0&CARD_TAB=-1)

> 后记： 欢迎加入我的私人公众号， 和你分享我思考的观点和文章：
![公众号二维码](http://ww2.sinaimg.cn/large/c5ee78b5gw1ezbljkk2apj20by0byq3q.jpg)
