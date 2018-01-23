title: 'Responsive web design[第三期]-js动画'
date: 2016-02-04 20:48:22
tags: [web design, javascript]
categories: 技术
---

Introduce greensock library to javascript, along with GPU acceleration to create high-quality and smooth animations. 

<!-- more -->

## Introduction

很多前端开发者会告诉你，你应该避免使用 JavaScript 动画。使用 CSS 动画会有更好的性能（更少的 CPU 时间）和更平滑的效果（更高的帧率）。

然而，JavaScript 动画慢的原因经常是因为你用的库并没有为动画进行优化。优化过的 JavaScript 动画引擎（比如 GreenSock 或 Velocity.js）有堪比 CSS 动画的性能。某些情况下 JS 动画甚至比 CSS 动画更快！可参考下面这个性能的比较， 最后发现在某些情况下greensock的性能会比jquery好上5-6倍
- [greensock](https://www.greensock.com/js/speed.html) 

## 引入greensock js库


```
TweenMax.fromTo("#box",1, {
    // from
    css: {
      left: "-200px",
    }
  },{
    // to
    css: {
      left: "200px",
    },

    // 永久重复动画的选项
    repeat: -1,

    // 反转、重新运行动画的选项
    yoyo: true,

    // 改变 easing 类型
    ease: Power2.easeInOut,
  }
);

```

> 什么是fps? 帧率或画面更新率是用于测量显示帧数的量度[1]。测量单位为“每秒显示帧数”（Frame per Second，FPS，帧率）或“赫兹”，一般来说FPS用于描述影片、电子绘图或游戏每秒播放多少帧，而赫兹则描述显示屏的画面每秒更新多少次。
由于人类眼睛的特殊生理结构，如果所看画面之帧率高于每秒约10-12帧的时候，就会认为是连贯的[2]， 此现象称之为视觉暂留。这也就是为什么电影胶片是一格一格拍摄出来，然后快速播放的。但30帧仅仅是流畅，而非平滑连续，因此有更多帧率的产品推出也就不足为奇了。
有声电影的拍摄及播放帧率均为每秒24帧，对一般人而言已算可接受，但对早期的高动态电子游戏，尤其是射击游戏或竞速游戏来说，帧率少于每秒30帧的话，游戏就会显得不连贯，这是因为电脑会准确地显示瞬时的画面（像是一台快门速度无限大的相机），没有动态模糊使流畅度降低。而使用相同帧率的摄影机拍摄物体移动时，该场景的视频必定会表现所有移动物体在曝光时间内所有位置的完整组合。因此很多新世代电玩游戏以动态模糊为特色。在实际体验中，60帧相对于30帧有着更好的体验。

在app.js里面我们用y来表现出垂直状态的变化

```
function animateLogo(){
	TweenMax.fromTo("#logo", 2.5, {
		css: {
			y: "-30px",
		}
	}, {
		css: {
			y: "20px",
		},

		repeat: -1,
		yoyo: true,
		ease: Sine.easeInOut,
	});
}
```

## GPU加速


你可以把一个网页想象为一堆矩形。布局和绘图都是由 CPU 完成的：

CPU 计算这些矩形的布局。矩形在哪里？它们有多大？
CPU 把矩形渲染成点阵位图（bitmap）。
之后如果可能的话，矩形被送到 GPU 以获得更好的性能：

CPU 以点阵位图的形式上传到 GPU 中。
CPU 给 GPU 发送指令去处理这些位图。可能有平移/缩放/旋转，修改透明度，等等。
GPU 为什么比 CPU 快呢？假设我们把一个红色点阵和一个绿色点阵结合，CPU 不得不一个一个像素地做.

总的来说，当修改 CSS 属性时，有三种可能的开销：

重排（CPU。代价最高）。
重绘（CPU）。
变换, 旋转, 缩放, 透明度（GPU，代价最低）。

因此在使用transform的时候， 我们常常用y在表示垂直方向的移动，这么做是不会重新排列布局的， 而是在局部位置偏移。
> 注意： left 只对 position: absolute 生效 

transform 的原理是由元素的定位位置（absolute or relative) 偏移。
用 GreenSocks 去修改 left 的话是改变定位位置。
也就是说 left 的动画改变布局，但 transform 动画不会改变布局。

## 多步骤动画

```
var t = new TimelineMax();
t.to("#box",1,{x: 200})
  .to("#box",0.5,{rotation: "360deg"})
  .to("#box",1,{y: 100})
  .to("#box",0.5,{rotation: "-=360deg"});
```

## 指示器(滚动指示条)


当窗口滚动时, 你可以用 window.scrollY 来算出窗口正在展示的是哪一部分。那么现在的重点就在于， 怎样可以获得关于元素所在位置， 高度的各种属性， 比如`scrollY`, `offsetHeight`, `offsetTop`
- [offset的各种用法实例](http://stackoverflow.com/questions/6777506/offsettop-vs-jquery-offset-top/21880020#21880020)

## 取消link默认行为


```
function addSmoothScrolling(){
	var links = document.querySelectorAll("#slider-control a");
	for(var i=0; i<links.length; i++){
		var link = links[i];
		var section = document.querySelectorAll("div.section")[i];
		(function(sec){
			// console.log(sec);
			link.addEventListener("click", function(e){
				// console.log(sec.offsetTop+"px");
				scrollToElement(sec);
				e.preventDefault();
			})
		})(section)
	}
}
```

首先用一个闭包来保证， 里面的函数在click的时候才之行， 而在那个时候， i 已经到了最后一个link的位置， 所以必须提前找到对应的section， 然后在闭包中传入。 同时需要在click事件的最后加上一个e.preventDefault， 来阻止link的默认行为， link的默认行为是直接跳转， 然后我们需要动画来辅助。



