title: 用reveal.js制作生日礼物
date: 2015-12-24 11:55:00
tags: [javascript]
categories: 技术
---

这篇笔记作为revealjs的学习记录 & 网页制作的迭代

<!-- more -->
![吹蜡烛](http://ww2.sinaimg.cn/large/c5ee78b5gw1ezadadm0hkg20dw07ndwp.gif)

1. 首先理清楚每天需要做的东西
   在tracy换头像的时候保存头像， 最后还需要大家帮忙把头像收集好；
   需要整理关于他们最爱的东西的问题：
   [1] 最喜欢的颜色？
   tracy: 黄色
   xth: 
   [2] 最喜欢的场景？
tracy: 雪天的时候在房间里面看雪景,  喝着热巧， 吃cookie，看雪景。
用飘雪的效果
xth: 萤火虫的效果
   
   [3] 
2. 网上一些很棒的资源
[Reveal.js Tutorial-Reveal.js for Beginners](http://htmlcheats.com/reveal-js/reveal-js-tutorial-reveal-js-for-beginners/)

[很美的萤火虫的特效scrolling](http://codepen.io/aamirafridi/pen/sfgGA)
[萤火虫闪光](http://codepen.io/rikschennink/pen/eNbXMP)
  
找css background gradient的一个好地方：
http://uigradients.com/#
   

### 开场特效：###
参考[click anywhere to start an animation!](http://codepen.io/andreasstorm/pen/rHDjf)
use:
```
$(html).on(‘mousedown’, function(e))
```
然后给中心的图标添加一个火箭发射的动效
   
关于reveal.js的在section的部分添加视频
<section data-background-video="https://s3.amazonaws.com/static.slid.es/site/homepage/v1/homepage-video-editor.mp4,https://s3.amazonaws.com/static.slid.es/site/homepage/v1/homepage-video-editor.webm" data-background-video-loop>

使用长图片做parallax scrolling effect:
https://github.com/hakimel/reveal.js/
的parallax background部分！！

   



   



   



   



   



   



