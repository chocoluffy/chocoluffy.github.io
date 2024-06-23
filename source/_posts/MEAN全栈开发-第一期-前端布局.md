title: 'MEAN全栈开发[第一期-前端布局]'
date: 2016-03-06 09:38:41
tags: [web design, javascript]
categories: 技术
---

AirLoft的原型。一个sharing economy的网站。 Loft是阁楼的意思， 每个心中那个静静守候一些秘密和癖好的地方。 有些情感， 只能在尘封的铁门后诉说， 就像有些话， 只讲给某个人听。厌倦了某些网站没有审美的UI， 也趁着青春轻狂， 去改变吧。第一期， 记录我前端页面开发的一些手记， 后面慢慢过渡到数据库和后台API设计。

<!-- more -->

## 前言

最近在做一个sharing economy的网站，在参考了大部分现有网站的UI的样式后， 我们感觉非常的不满😂(当然像quora这种属于知识信息密度特别高的网站使用文本密集的形势还说的过去)， 但是像airbnb还有携程这种大型的peer sharing的网站， 如何可以从第一屏就吸引到用户是一个很重要的问题。直接上图看看：
首先是[airbnb](https://www.airbnb.ca/)的网站：
![airbnb website](http://ww1.sinaimg.cn/large/c5ee78b5gw1f1mrezw5z0j21kw0t9dqn.jpg)
airbnb在网站的第一屏是用一段视频来当做背景的， 非常惊艳， 但是第一屏没有满屏是什么意思？是想吸引我们可以往下滚嘛？但是这种样式让我非常不舒服， 明明有非常好的创意， 为什么不像这个[thenewcode.com](http://thenewcode.com/samples/polina.html)一样使用高清全屏的视频来当做网页背景呢， 很惊艳对不对!!

再看一下[携程](http://www.ctrip.com/#ctm_ref=nb_cn_top)的网站， 感觉还是滞留在上个世纪的UI。
![携程website](http://ww2.sinaimg.cn/large/c5ee78b5gw1f1mrhyoxpvj21kw0t7qiu.jpg)
于是， 也是出于对颜值的追求，我决定尝试使用轮播在第二屏的网站展示页面来展示各个兴趣小组（比如一起做早餐吃早餐啦， 一起go hiking啦， 一起复习期末考写作业的兴趣小组啦）

考虑到完整项目的时间紧迫， 就不准备在前端的js的代码上花太多时间， 毕竟后面还有转移到express的jade模版， 然后最后还要用angularjs来重写。 于是我就在找各类比较好的carousel的js插件， 在比较了几个的表现之后， 还是[superslides](https://github.com/nicinabox/superslides)最得我心。废话不多说， 直接上实例代码：

```
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Superslides - A fullscreen slider for jQuery</title>
  <link rel="stylesheet" href="../dist/stylesheets/superslides.css">
</head>
<body>
  <div id="slides">
    <div class="slides-container">
      <img src="images/people.jpeg" alt="Cinelli">
      <img src="images/surly.jpeg" width="1024" height="682" alt="Surly">
      <img src="images/cinelli-front.jpeg" width="1024" height="683" alt="Cinelli">
      <img src="images/affinity.jpeg" width="1024" height="685" alt="Affinity">
    </div>

    <nav class="slides-navigation">
      <a href="#" class="next">Next</a>
      <a href="#" class="prev">Previous</a>
    </nav>
  </div>

  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script src="javascripts/jquery.easing.1.3.js"></script>
  <script src="javascripts/jquery.animate-enhanced.min.js"></script>
  <script src="../dist/jquery.superslides.js" type="text/javascript" charset="utf-8"></script>
  <script>
    $('#slides').superslides({
      animation: 'fade'
    });
  </script>
</body>
</html>
```

忽略其他的不管， 如果我们希望引入superslides的功效， 我们只需要添加这几个tag:

```
<!--css-->
<link rel="stylesheet" href="../dist/stylesheets/superslides.css">

<!--js-->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="../dist/jquery.superslides.js" type="text/javascript" charset="utf-8"></script>
```

注意jquery的引入要在superslides的前面， 来保证superslides在引用的时候可以用到jquery里面的定义的函数。

在添加了css和js之后， 我们就可以来创建全屏图片轮播的html结构了， 官方推荐的是在`<div id="slides">`里面放一个div里面放各种img， 或者也可以使用一个`<li>`来分开img和div来在后期分别写样式和定位， 我在我的项目中使用的就是后者， 比如：

```
<div id="slides">
  <ul class="slides-container">
    <li>
      <img src="http://flickholdr.com/1000/800" alt="">
      <div class="container">
        Slide one
      </div>
    </li>
    <li>
      <img src="http://flickholdr.com/1000/800/space" alt="">
      <div class="container">
        Slide two
      </div>
    </li>
    <li>
      <img src="http://flickholdr.com/1000/800/tech" alt="">
      <div class="container">
        Slide three
      </div>
    </li>
  </ul>
  <nav class="slides-navigation">
    <a href="#" class="next">Next</a>
    <a href="#" class="prev">Previous</a>
  </nav>
</div>
```

由于我的网站背景颜色是暗色系的， 我添加了`reveselay`和`overlay`来创建两个mask来写出渐变渐出的效果， 这样可以很好的和背景颜色混为一体。

```
        <div class="section" id="android">
          <div class="containerrow">
            <div id="slides">
              <ul class="slides-container">
                <li>
                  <img src="./image/desk.jpg" alt="">
                  <div class="reverselay"></div>
                  <div class="overlay"></div>
                  <div class="mainbadget">
                      <h5>
                        <span class="glyphicon glyphicon-user"></span>&nbsp;134 &nbsp;&nbsp;
                        <span class="glyphicon glyphicon-fire"></span>&nbsp;3440
                      </h5>
                  </div>
                  <div class="text-container">
                    <div class="maintitle">
                       <a href="">Morning Call</a>
                    </div>
                    <div class="maintext">
                      <p>Join our breakfast cooking club for fresh pancakes and sunshine!
                      Meet your friends here and enjoy every piece of buttered toast. <a href="">See more.</a></p>
                    </div>
                  </div>    
                </li>
              </ul>

              <nav class="slides-navigation">
                <a href="#" class="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
                <a href="#" class="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
              </nav>
            </div>
            
            <div id="slider-control">
              <a href="#react" class="active">
                <div class="dot"></div>
              </a>
              <a href="#intro">
                <div class="dot"></div>
              </a>

              <a href="#native">
                <div class="dot"></div>
              </a>

              <a href="#touch">
                <div class="dot"></div>
              </a>

              <a href="#android">
                <div class="dot"></div>
              </a>
            </div>
          </div>
        </div>
```

注意我这里的`text-container`, `maintitle`, `maintext`都是用来创建overlay在图片上面的文字， 分离出来比较方便定位。最后记得要初始化js：

```
        <script>
          $('#slides').superslides({
            animation: 'fade',
            play: '8000'
          });
        </script>
```
