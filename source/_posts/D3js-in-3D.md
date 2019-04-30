title: D3js in 3D
date: 2015-12-30 12:30:59
tags: [javascript]
categories: 技术
---

Create a virtual-reality-like scene in mobile and desktop. Using D3js to do the math! Check out [Live Demo](http://chocoluffy.com/d3js3D/) now!

<!-- more -->

Inspired by [d33d](https://www.youtube.com/watch?v=Tb2b5nFmmsM), 💣** [Live Demo](http://chocoluffy.com/d3js-Aframe/) **

## Build up a local server to avoid cross-origin error

we know that using <a-image> can do insert the image. Due to the cross-origin problem, in local testing, we need to use a local server to host the static file and its assets, such as images so that when used in html file, it will not cause a cross-origin error. The way we build up a temporary server is to use python. First cd to the corresponding directory, then do:
```
python -m SimpleHTTPServer 8000
```
Then go to the localhost:8000 can see the files. For more detailed info, check [this post](http://stackoverflow.com/questions/8456538/origin-null-is-not-allowed-by-access-control-allow-origin) in stack overflow.

## How to append tag in multiple nodes
references [this post](http://stackoverflow.com/questions/24318154/d3-js-append-on-existing-div-and-hierarchy) from stack overflow

## Color palette
references [this website](http://paletton.com/#uid=10M0u0kiRKW0VGw8oOOrBQoTc+M)

## How to host your static page in github

references [this post](https://help.github.com/articles/creating-project-pages-manually/)

The final result will be, you can access the project site from your github.io website with a branch. The procedure goes well, but it seems that gh-pages cannot host a d3 or aframe pages? Answer: YES, SURE WE CAN!!! for more info, you can just visit [my website](https://chocoluffy.github.io/d3js-Aframe/), github can host static website for free, so what kind of websites can be called as static? we called those sites as “static” as it only involves client-side scripting if it contains js file. Those who need server-side scripting are called dynamic websites.

> note that in order to use gh-pages to host my project website, you need to name the html file to be `index.html`. Other file name will not be recognized!!

To summarize, the basic procedure is:

```
git clone … // from github, copy the repo’s https
cd …
git checkout - -orphan gh-pages
git rm -rf .
```
Then now, the gh-pages should be empty. Move the prepared `index.html` to here then
```
git add -A
git commit -m “First commit”
git push origin gh-pages
```
Then, go to www.chocoluffy.com/<your-project-name>, you can see the project site!!

## How A-frame works
```
    <a-assets>
      <a-mixin id="red" material="color: red"></a-mixin>
    </a-assets>
    <a-scene>
      <a-entity camera look-controls wasd-controls></a-entity>
      <a-entity light="type: point; color: #EEE; intensity: 0.5" position="0 3 0"></a-entity>
      <a-light color="#da47da" position="0 0 0" type="ambient"></a-light>
      <!-- <a-sky color="#c8f8e0"></a-sky> -->
      <a-sky src="road.jpg"></a-sky>
    </a-scene>
```
References [this website](https://aframe.io/docs/primitives/a-sky.html) for more A-frame primitives.

Then by using d3js, we can add corresponding number of <a-entity> to the scene from data array.

```
<script>
      var data=[10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
      var tip = -0.5;
      var radius = 6;
      var scene = d3.select("a-scene")
      scene.append("a-camera")
           .attr({
            position: function(){
              var x = 0;
              var y = tip;
              var z = 0;
              return x + " " + y + " " + z
            }
           })
      var cubes = scene.selectAll("a-entity.bar").data(data)
                  .enter()
                  .append("a-entity")
                  .classed("bar", true)
                  .attr({
                    // mixin: "link",
                    material: "color: #7BC8A4",
                    geometry: "primitive: box; width: 2; height: 2; depth: 2",
                    position: function(d, i){
                      var theta = (i / data.length) * (2 * Math.PI);
                      var x = radius * Math.cos(theta); 
                      var y = 0;
                      var z = radius * Math.sin(theta);
                      return x + " " + y + " " + z
                    },
                    rotation: function(d, i){
                      var x = 0;
                      var y = -360 * i/data.length;
                      var z = -80*Math.atan(tip/radius);
                      return x + " " + y + " " + z
                    }
                  })
    cubes.append("a-mouseenter")
         .attr({
            // scale: "1 2 1",
            position: "0 2 0",
            visible: false
         })
    cubes.append("a-mouseleave")
         .attr({
            scale: "1 1 1"
            // position: "0 2 0"
            // visible: true
         })
```
Find the structure of this scene, it will like having several `<a-entity>` inside `<a-scene>`, and each of `<a-entity>` has multiple attributes that defines its position, rotation, material and geometry. And inside the `<a-entity>`, also has  `<a-mouseenter>` and `<a-mouseleave>` tags which helps define the actions when hovered. 










