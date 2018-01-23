title: rails开发笔记-instagram
date: 2015-08-31 22:04:00
tags: [rails]
categories: 技术
---

用了一天的时间完成了这个网站的开发，SearchInsta， 也算是一个阶段性的总结。

<!-- more -->
![image](http://mmbiz.qpic.cn/mmbiz/oXichwD6Wg3liaa80EeoviaAB01GKkyjG6qp26GB1Mm409ZKPy3NRDqbD6xeG6hgdjfyN9ic3bEQtwQGsArZ53PxmQ/0?wx_fmt=jpeg)
用了一天的时间完成了这个网站的开发，SearchInsta， 也算是一个阶段性的总结。  
![image](http://mmbiz.qpic.cn/mmbiz/oXichwD6Wg3liaa80EeoviaAB01GKkyjG6qB5xCWEgEH979oIdDSpPMiaW1oLIHtpVECbY3ZQxNBXnKw33rFBh2gMQ/0?wx_fmt=png)  
  
  
  
  
当鼠标hover其中一个照片时：  
  
  
![image](http://mmbiz.qpic.cn/mmbiz/oXichwD6Wg3liaa80EeoviaAB01GKkyjG6qzKjPRxEFgZdPbcicyDcSxaRCAh34H7EKK5O2Na5gIEwlZbYjXchB3rQ/0?wx_fmt=png)  
  
  
  
  
网站的功能：输入一个image tag或者用户名， 可以看到这个类别下面最新发布的post， 鼠标hover的时候可以看到用户的post原文。  
  
  
原理：其实这个很简单的， 就是调用了instagram的api，然后做的一个数据抓取和呈现而已。 不过在改进方向上面有很多可能。 我也会继续在功能上做出完善。比如：   
  
  
1. 我可以通过api得到用户之间的follow关系， 那么利用d3.js里面的一些三维模型函数库， 也就可以做出一张动态的关系网出来， (这种社交网络结构在商业ppt上可能比较常见吧)； 还记得大一去MIT决赛的时候， 中科大的那个结构网的作品， 结合图论上的一些shortest path, maximum flow的原理还可以找到最高效的关系连通path。在这个instagram的情景中，这个“最高效的”仍然需要人们定义， 比如可以定义成获得的点赞数最多， 社区声誉最好？购买力最高， 广告转化率最高等的指标。  
2. 通过获得的geolocation的数据， 可以结合一些数据处理包完成地图上tag发布热点区域的绘制， 用户发布的地点时间的集合，（现在吐槽最多的不就是O2O startup，现在都可以拿个google map的地图和一些头像就去融资了不是吗)。   
3. 获得某一个tag当前最新的， 或者最热的图片， 那其实也可以变相给用户推荐图片， 像feed一样， 不过这个时候用户看到的不就只是自己follow的人, 而是门户filter后的资源， 这个方向走下去基本就是社交媒体了， 那种编辑、发布的， 控制资源的channel。   
4. 对用户的描述做语义分析， 然后利用统计手段得到某个特定用户的发布资源的特点， 或者某个特定群体的common tag\interests。 实现方式也不算复杂， ruby里面的nokogiri gem可以parse掉html结构， 得到的json数据再去统计整合处理。 但就像我前几天做得一个小项目中遇到的问题。 英文可以很方面的根据词语出现过的频率来统计， 然后去掉预设的meaningless的词语后得到， 然后筛选可以得到概括； 但是对于中文， 毕竟parse之后只能得到单个的字， 而不是一个个完整意义的词语， 所以给后期过滤中心主体带来了很多困难， （为什么不能得到词语？ 答：技术上只能得到一个个单个字， 就像英文一个个单词一样， 你必须定义怎样算一个中文词语的规则， 以及怎样才是原文里面的那个词语搭配规则才能得到一个完整的意群）这也是当时困扰我的一个问题， 或许互联网上有很多人、企业遇到过这个问题， 我会继续去关注。  
5. 根据用户发布的post的点赞数或者是转发数量的一个统计分析、排序， 做出一个类似facebook的 the best of the years， 虽然在隐私上仍然有着一些抵触的情绪， 但是当用户看到这些曾经很棒的、很希望分享的照片不都挺惊讶和开心的吗。  
6. 打通twiiter \ weibo \ facebook api之间的联系？ 可以做到站内的消息多平台的发布和浏览。  
  
  
等等...  
  
  
这些基本都是我debug之后挺高兴地走去吃饭路上想到的一些延伸， 能写出来的都是大概心里有个想法知道方向在哪里的， 可以做出来的。 那些有些天马行空的就自己留着暂时不分享了。 其实这一天的时间里面我在前端设计上花的功夫比我在后端请求数据和处理的功夫多太多了， 而问题都基本都出在一些动效和细节上面， 不过一仔细起来， 真的很多地方的设计都学到了东西；  
  
  
 比如怎样做出这样类似纸张微微隆起的漂亮阴影效果：  
   
   
![image](http://mmbiz.qpic.cn/mmbiz/oXichwD6Wg3liaa80EeoviaAB01GKkyjG6qzW0y2WJqB8oJXFdxXE3ZqCYcFvywrnXT97u69vUWvvTg93VxiaP9rNw/0?wx_fmt=png)  
  
  
   
 一些优雅的google fonts的收集、bootstrap里面超级flexible的grid system。还有很多很多， 之后的优化应该要集中在抽象上面了， 做到真正orthogonal \ extensible的模块真的不简单， 我函数里面hard-coding还是太多了。   
   
 其实刚刚在一边写这些extensions的时候， 就感觉， 数据的意义和价值都是设计者思维的体现。 一场惊艳的交互， 一个有商业价值的发现， 都离不开设计者的融会贯通。  
   
 希望能在全栈工程师的路上可以走的更远。  
   
今天看到的一句很喜欢的话， 和大家分享：  
  
  
孤独被抬举和神化， 寂寞也并不可耻。多数时候， 我们只是寂寞， 不必用孤独为自己加冕。  
