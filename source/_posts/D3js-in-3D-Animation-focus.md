title: 'D3js in 3D [Animation focus]'
date: 2015-12-31 12:14:50
tags: [javascript] 
categories: 技术
---

Focus on how animations work in such 3D scene and how I achieve that. [Live Demo](http://chocoluffy.com/d3js3D/) here! 

<!-- more -->

![Animation](http://ww3.sinaimg.cn/large/c5ee78b5gw1ezjckugw4nj21kw0ncn9h.jpg)

## Animation

One key thing for such 3D scene is animations and we need a lot of interaction to finish that cooperation. Thus, in usual, we need to add multiple event listener to many sibling elements and the way we did that is by creating a parent element and by utilizing the event propagation to achieve the goal.

Say, we have a lot of `<a-cube>` now, and we want to add the click event listener to the `<a-cube>` below to trigger the animations of the `<a-cube>` above the scene. [The way we add animations is to append tag `<a-animation>`  as the childNode of the `<a-cube>`]. Now, in order to do that attachment in one time, we need to group all the `<a-cube>` into a container, we can just use a `<a-entity id=“meteor”></a-entity>` to do that thing. So we can add the click event listener at the parent node, and when the childNode get clicked, the event will propagated to the parent level by level, and back then when it achieve the targeted parent. we can trigger the function and do all the `append` or other actions on `e.target`. [here `e.target` refers to the one get clicked]. 

In the later interaction. we want the action of one object may trigger another object’s actions. Then, we need to leave such mark to indicate which object may be related to! For example, in my code, I use  a data-attribute called “flag” as a id to indicate which object to bind. So later in the eventListener, we can use `e.target.getAttribute(“flag”)` to obtain that value for further use like `meteorParentNode.childNodes[e.target.getAttribute(“flag”)].append()` some animation nodes to the “meteor”!!

## Image on meteor

In order to make it a fun, I decided to use image as the surface of the meteors ,  and the way to achieve that is to wrap a tag `<a-root>` and a tag `<a-entity>` further inside. So now the structure will be like:
```
<a-entity some-attributes-here>
	<a-root>
		<a-entity some-attribute-here>
```
And set the src to be some texture image or even in this project some funny images as the surface of the meteors. And that’s it! 

## Further Reading

- [Aframe in tumblr](http://aframevr.tumblr.com/)
- [Official Aframe animations guide](https://aframe.io/docs/core/animation.html)
- [How to add texture for Aframe objects](http://projects.bmannconsulting.com/aframe-boilerplate/)
- [How to add event listener to multiple sibling elements](http://www.kirupa.com/html5/handling_events_for_many_elements.htm)