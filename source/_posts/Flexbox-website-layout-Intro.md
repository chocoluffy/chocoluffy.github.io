title: Flexbox website layout - Intro
date: 2016-01-12 12:00:52
tags: [web design]
categories: 技术
---

My first attempt to build up a responsive website using Flexbox layout. Check [Live Demo](http://chocoluffy.com/flex-layout/) here!

<!-- more -->

![overview](http://ww3.sinaimg.cn/large/c5ee78b5gw1ezx7kdisiuj21kw0r1di7.jpg)

check [this post](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) on the complete guide about Flexbox layout.

> Below is the code that can be applied to many text\presentation related website. [1] font is cool and elegant. [2] layout is fast since we set div to `display: flex`. We won't be bother to type that anymore, focusing on "position" and "stretch"

```
body {
  background-color: #1F1E34;
  color: #FFF;
  font-family: "Avenir Next",
      "HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica,
      Arial, "Lucida Grande", sans-serif;
  font-weight: 100;
}

h1 {
  font-size: 64px;
  font-weight: 100;
}

h2 {
  font-size: 48px;
  font-weight: 100;
}

p {
  font-size: 24px;
}

a {
  font-weight: 400;
  color: #FFF;
}

a:hover {
  font-weight: 400;
  color: #DADADA;
  text-decoration: none;
}
```
especially the font, it is so beautiful!

These units are vh (viewport height), vw (viewport width), vmin (viewport minimum length) and vmax (viewport maximum length). we set the vh to 100 like this:
```
.container {
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
}
```
for the parent div container, since we want that parent div can take up a viewport height. vh stands for "viewport height"

> Note that `flex-direction` indicate items' aligning, rows or columns. Then `align-items` means main-axis and `justify-content` is for sub-axis.

## flex

在使用 ReactNative 时你会经常看到一个神秘的设定 flex: 1，用了来扩大一个 flexbox。flex 是一个简写，同时设置 flex-grow，flex-shrink 和 flex-basis 三个属性。它们的默认值为：

 ```
flex: 0 1 auto;
/*
flex-grow: 0;
flex-shrink: 1;
flex-basis: auto;
*/
```

flex: 1 意为 flex: 1 1 auto

## Summary For All

basically using some flex-related properties to structure the whole website.

[1] to formate those section-like website, need to use `section` tag in html file and set the corresponding containter to be `100vh` which means the viewport height, so that each section can be strecthed to adapt to your screen height. (which is pretty elegant)

we usually use 

```
  flex-direction: column;
  align-items: center;
  justify-content: center;
```
these properties as container's property.
> Note that we have main-axis and sub-axis, which will help you position the items by `align-items: center;
  justify-content: center;`
  

[2] structure inside each section. we may use another flexbox container inside one parent container to hold up more items like navigation or some scrum-map. And in this way, the `flex-direction` may usually be the opposite to the parent container. For the child container, we may wonder to stretch the block to whatever proportion to the whole layout. we want to use
```
  flex-grow: 1;
  flex-basis: 0;
  align-self: stretch;
```
which also applies the same logic from main-axis and sub-axis when setting their values.

Note that the `flex-basis` is pretty useful when you try to eliminate the effect of inner text to the block when stretching since `align-self: stretch` ONLY stretch the empty space to full length!

















