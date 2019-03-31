title: 'Responsive web design[第二期]-position/overlay'
date: 2016-01-20 15:50:19
tags: [web design]
categories: 技术
---

在使用position等css属性的时候会经常在'absolute','relative'和'static'上进坑。 本文从实战的角度介绍position的各种应用和如何添加一层优雅的渐变背景过渡层。

<!-- more -->

## position: static

when dealing with nested container, the parent div is usually set to be `position: relative` while child div is `position: absolute` so that the child element can be positioned to any pos within parent container, if the parent div is set to `position: static`, child element will ignore parent position.

> Note that `position: static` is CSS default setting, so if we want to use `position: absolute`, we should always set the parent element to `position: relative`. ReactNative set the default value back, so no worries.

when use position properties like `top` and `left`, we usually set them to `50%`, but the result will be like the element’s top left corner is sticked to the center, while the rest of it is not at the center, which is not what we want, we usually use `transform` property and get it to `-50%` to center the element.

```c
top: 50%;
left: 50%;
transform: translate(-50%, -50%);
```

这里我们要说说 static 元素的另外一个坑。

absolute, relative: 有 z-index。
static: 没有 z-index。
没有 z-index 的元素默认在有 z-index 的元素下面。

img 和 h1 元素都是 position: static。z-index 对 static 元素不起作用，因此它们都在绝对定位的元素下面。

## position: relative

接下来看看我们嘴经常见到的`position: relative`。
简单地说， 就是在这个元素原本的位置上做位移， 因为有了`position: relative`的设定， 我们可以用`top``left`来移动这个元素。
If you specify position:relative, then you can use top or bottom, and left or right to move the element relative to where it would normally occur in the document.

Let's move div-1 down 20 pixels, and to the left 40 pixels:
```
#div-1 {
 position:relative;
 top:20px;
 left:-40px;
}
```
Notice the space where div-1 normally would have been if we had not moved it: now it is an empty space. The next element (div-after) did not move when we moved div-1. That's because div-1 still occupies that original space in the document, even though we have moved it. 效果参考：![position relative](http://ww3.sinaimg.cn/large/c5ee78b5gw1f08roukzilj20ry0lwjw8.jpg)

另外， position:relative 还带来了z-index的属性。
- references from [Absolute, Relative, Fixed Positioning: How Do They Differ?](https://css-tricks.com/absolute-relative-fixed-positioining-how-do-they-differ/)
There are two other things that happen when you set position: relative; on an element that you should be aware of. One is that it introduces the ability to use z-index on that element, which doesn't really work with statically positioned elements. Even if you don't set a z-index value, this element will now appear on top of any other statically positioned element. You can't fight it by setting a higher z-index value on a statically positioned element. The other thing that happens is it limits the scope of absolutely positioned child elements. Any element that is a child of the relatively positioned element can be absolutely positioned within that block.

## position: absolute

如果我们使用`position: absolute`呢, 这个元素将会脱离文本， 我们可以人意将它摆放到的想去的位置， 注意和static的区别是， 这个absolute是相对_**上一个定位为relative**_的定位， 而static是相对浏览器的定位。

```c
#div-1 {
 position:relative;
}
#div-1a {
 position:absolute;
 top:0;
 right:0;
 width:200px;
}
```

效果参考：![relative and absolute](http://ww4.sinaimg.cn/large/c5ee78b5gw1f08rtih4o4j20pe0iadk1.jpg)

> 最后一个补充：我们常常和`float`搭配使用的`clear: both`, 作用是使得定义了该属性的元素的左侧和右侧均不允许出现浮动元素。



## 滚动控制

```c
<div id="slider-control">
  <a href="#native" class="active">
    <div class="dot"></div>
  </a>

  <a href="#touch">
    <div class="dot"></div>
  </a>

  <a href="#async">
    <div class="dot"></div>
  </a>

  <a href="#flex">
    <div class="dot"></div>
  </a>
</div>
```

让它们position: fixed, 效果参考：

![movement control](http://ww3.sinaimg.cn/large/c5ee78b5gw1f06g8ze3fhj20yo0pw76w.jpg)



## overlay 平滑过渡

```c
        <section>
            <div class="container" id="intro-section">
            <div class="overlay"></div>
            <h1>I Love React</h1>
            <p>I just want to see the so-called live-coding</p>
            </div>
        </section>
```

将最上面的container的背景设置为图片背景， 然后中间加一个div.overlay的div, 然后通过渐变设置其背景为主背景颜色。

```c
#intro-section{
  background-image: url(../image/background.jpg);
  background-size: cover;
  background-position: center;
}

#intro-section h1, p{
  position: relative;
  z-index: 1;
}

.overlay{
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: linear-gradient(rgba(0,0,0,0),rgba(22, 21, 37, 1));
}
```

![overlay](http://ww4.sinaimg.cn/large/c5ee78b5gw1f06lr99d5xj21kw0q47cw.jpg)

## 参考资料

- [hex to rgba online converter](http://hex2rgba.devoth.com/)
- [ilovereact](https://github.com/luckymore0520/sike-react-ilovereact)
- [最后成品效果ilovereact－添加动画](http://gugugupan.github.io/sike-react-ilovereact/)
- [上面github项目的index.html](https://github.com/gugugupan/sike-react-ilovereact/blob/master/index.html)