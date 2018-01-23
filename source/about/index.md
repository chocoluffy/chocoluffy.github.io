title: 关于我
date: 2014-12-31 22:30:10
tags: 
categories:
---

95.11.04，现多伦多大学大四学生，主攻机器学习方向，曾GAP一年在Sysomos的实验室参与数据分析挖掘的实习项目，现创业中。喜欢编程，喜欢实现想法的自由。

- 『[我的技术笔记](http://chocoluffy.com/tech/)』
- 『[我的生活随笔](http://chocoluffy.com/life/)』
- 『[我的书房](http://chocoluffy.com/books/)』
- 『[我的Github](https://github.com/chocoluffy)』

永远年轻，永远热泪盈眶。

我觉得自己挺感性的，虽然身为一名理科学生。我喜欢海贼王，那种与伙伴并肩战斗的感觉，喜欢新闻编辑室，传统媒体在面对各种改变和挑战时那种高贵的英雄主义，喜欢巴萨，血统里优雅的足球艺术，喜欢唐吉柯德，没有从梦中醒来的骑士…

我始终相信，一个人的气质中，藏着曾经读过的书，走过的路。

想像路飞那样一直拼下去，当一个人有了真正想要守护的东西，他才会真正变得强大。

“One Piece到底存不存在，我不想知道。”

或许将永远困惑，但也将永远寻找。困惑是我的真实，寻找是我的勇敢。

<!-- more -->

## My Projects

### Whalesper - Toronto life at your fingertip - March 2017

- Ranked 4th at App Store Toronto search results, ranked top at Toronto News results.
- I launched my product, Whalesper, and founded a startup, Whalesper Inc, during this summer, originally as an AI-powered local news and services’s aggregator. With iOS version supported, we harvested nearly 9.6K users around Toronto area. 
- The ultimate goal is to connect people with their neighbor micro-services.
- Full release note see [here](http://chocoluffy.com/2017/03/20/App%E9%A6%96%E5%8F%91%EF%BD%9C%E9%B2%B8%E8%AF%AD-%E5%A4%9A%E4%BC%A6%E5%A4%9A%E7%8E%A9%E4%B9%90%E6%94%BB%E7%95%A5%E7%AC%AC%E4%B8%80%E5%85%A5%E5%8F%A3/), Download it [here](https://itunes.apple.com/ca/app/%E9%B2%B8%E8%AF%AD-%E5%A4%9A%E4%BC%A6%E5%A4%9A%E7%8E%A9%E4%B9%90%E6%94%BB%E7%95%A5%E7%AC%AC%E4%B8%80%E5%85%A5%E5%8F%A3/id1196585674?mt=8)

<img src="https://ww1.sinaimg.cn/large/006tKfTcgy1fko0120g1nj30xc0xcwg8.jpg" style="display: block; margin: 0 auto; height: 300px">

### Approximate Neighbor Search & Chatbot - December 2016

- My talk at Sysomos's Data Science Lab, see [link](https://docs.google.com/presentation/d/1QA_91iqOjExL7pIOm7K9d-BUiKl5aerbAykEUHUzfZQ/edit?usp=sharing) here.

<img src="http://ww4.sinaimg.cn/large/006y8lVagw1farb9x2ggqj31kw0w1q66.jpg" style="display: block; margin: 0 auto;">

### Autonomous Driving - December 2016

- A computer vision project focusing on car detection and viewpoint prediction, ten-fold cross validation accuracy achieves 94% on [KITTI  Dataset](http://www.cvlibs.net/datasets/kitti/eval_object.php)
- Raise the idea of "visual viewpoint" in extend of object's actual viewpoint, to allow exposing more consistent features to classifiers. The highest accuracy rate among all undergraduate and graduate students so far.
- My Idea: DPM + SVM(rbf kernel) + intense image preprocessing

<img src="http://chocoluffy.com/demo-gif/auto-driving.gif" style="display: block; margin: 0 auto;">
<img src="https://ww4.sinaimg.cn/large/006tNc79gy1flusnl0jd1j312o0nsb29.jpg" style="display: block; margin: 0 auto;">

### Video Image SmArt collaGE - August 2016

- VISAGE(Video Image SmArt collaGE) aims to extract the most important scenes from a clip of social video. It composes those frames into a collage for better understanding on the video content.
- A Computer Vision project that focuses on measuring images similarity from each frames of the video. And we designed an algorithm to measure how important one frame is from that video(roughly by how long it elapsed).
- My Idea: openCV + FFMPEG(with ImageMagick) + python(Flask) + Jquery. 

### React Native EveryDay - Nights in 2016

- A every day challenge for myself to hone my skills in mobile development, especially with React Native. Make a small but functional prototype with different interesting ideas implemented.
- My Idea: React Native + redux. [Github Source and some lovely demos!](https://github.com/chocoluffy/ReactNativeEverydayDemo).


### Content Recommendation System - July 2016
- Based on TF-IDF and cosine similarity to measure the similarity between posts, users can upload any texts to receive a matching results, which can be used for "You may also like" part in any social product.
- Backend build with python flask, with nodejs handling user input and serving information to flask.
- Over 66 articles from UT(University of Toronto) assistant have been processed as database seed data, and it will be updated seamlessly with authenticated upload. This system has been integrated into wechat's public channel. [Github Source](https://github.com/chocoluffy/wechat_web_scraper)

![demo](http://ww3.sinaimg.cn/large/006tNbRwgw1f5xu48r9gvj319a0um163)

### SOS(Sentiment on Sentences) - June 2016
- Using sentiment analysis techniques to infer user-input sentences' sentiment on the fly. Model is pre-trained by Naive Bayes and SVM classifiers, based on twitter massive tweet data. In other words, the output sentiment results can to some extends reflect how people think over that topic currently. Super interesting!
- Built with react native, migrated from a node.js web app. Get my hands dirty with RN's amazing mobile support.
- Part of my react native everyday coding challenge. [Github Source](https://github.com/chocoluffy/ReactNativeEveryday/tree/master/Day2Sentiment).

<img src="http://chocoluffy.com/demo-gif/emocean.gif" style="height: 500px;">


### AirLoft  January - March 2016

* A MEAN full-stack project for a peer sharing topic. We want you to share your habits and insights with the world around you!
* A complete javascript stack project involving server-side Express and front-side Angular. 
* Nice display! [Github Source](https://github.com/chocoluffy/AirLoft), [Live Demo](https://frozen-ocean-17990.herokuapp.com/), [Video Demo](https://www.youtube.com/watch?v=mpkWh4_-L_E).

### Tweets Ocean - Feburary 2016

* A hand-on Nodejs project, using Ajax to request for tweets json file and use Bootstrap\fontawesome for pretty display.
* Involved javascript programming both client side and server side. Desire to learn more on Nodejs.
* A elegant display with background lighthighting and informatio alert.

![project gif](https://zippy.gfycat.com/FancyWeeBrontosaurus.gif)

### NLP on tweets - Feburary 2016

- A hand-on natual language processing project of up to 11000 tweets on sentiment analysis.
- Involved python programming, part-of-speech(PoS) tags, machine learning with WEKA, and IBM Watson on BlueMix.
- Finally accuracy of 67% on test data with Naive Bayes classifier.

### [Donut Hero](http://chocoluffy.com/html5touch/) - Feburary 2016

- A html5 canvas game with fancy particle and ripple effects.
- Fully-functional game looping logic with modular javascript files for each game components.
- [Github repo](https://github.com/chocoluffy/html5touch)

![project gif](http://chocoluffy.com/demo-gif/donut-hero.gif)

### [Virtual Reality World](http://chocoluffy.com/d3js3D/) - January 2016

- A virtual reality website gift for my friends' birthday!
- Heavily use D3.js to simulate the spining bomb objects, and use Aframe.io to build the virtual scene. 
- [Github repo](https://github.com/chocoluffy/d3js3D)

<div style='text-align:center' markdown='1'>
  <iframe src="http://chocoluffy.com/d3js3D/" width="100%" height="600">
    <p>Your browser does not support iframes.</p>
  </iframe>
</div>

### [I Love React](http://chocoluffy.com/flex-layout/) - January 2016

- A CommonJS modular project site, initialized as npm project.
- Introduce Greensock.js animation library and accelerate animations with GPU.
- A interesting attempt at ScrollMagic.js
- [Github repo](https://github.com/chocoluffy/flex-layout)

### Emocean November - December 2015

- A machine learning project dedicated to recognize human facial expressions and achieves up to 82% of accuracy on [The Toronto Faces Dataset](http://www.aclab.ca/).
- Ranked the 6th out of about 1600 entries among all undergraduates and graduates on Kaggle website.
- My Idea - Neural Nets on local features + SVM(with PCA) + KNN + Ensemble Methods(mixture of experts). 
- Link on the [final paper](https://www.dropbox.com/s/06q1jwcvqpo3ti5/Report%20on%20Facial%20Expression%20Recognition.pdf?dl=0)

### TalkerHub March – May 2015

- A social media website inspired from Twitter, based on ruby on rails, hosted with Amazon S3. Users can upload their images with filters options built-in on website. Allowing users to follow other users and see their latest posts.
- My Idea - Rails + Bootstrap + Jquery + multiple ruby gems.

### Groomie June 2015

- A search engine designed specifically for instagram feeds. Users can type in certain key words and the engine will scape related feeds(latest and most-liked) from Instagram API, and display in a more compact but elegant way.
- My Idea - Rails + Bootstrap + Jquery + multiple ruby gems.

![screenshot](http://ww1.sinaimg.cn/large/c5ee78b5gw1f1k16o74lgj21kw0s5wir.jpg)



## My Resume

![My Resume](http://ww4.sinaimg.cn/large/7853084cgw1facupovsmpj21g80zkn8p.jpg)

[Download it here](https://www.dropbox.com/s/94y6dyqgmeqpwoc/resume_Dec2016.pdf?dl=0)

