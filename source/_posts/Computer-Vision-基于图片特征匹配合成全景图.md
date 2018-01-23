title: Computer Vision - 基于图片特征匹配合成全景图
date: 2016-11-07 20:56:36
tags: [machine learning, computer vision, matlab]
categories: 技术
---

这一次尝试解决的问题是: 假如你希望有一幅风景的全景图(panaroma)，但是你手头上只有一堆关于该风景不同角度的图片， 怎么利用computer vision学习到的方法来合成一张全景图。

<!-- more -->


## 前言

这学期虽然在公司实习， 但同时我也在学校part time了一门computer vision的课程。Computer Vision，说白了就是结合image recognition和machine learning的方法来训练机器能够识别和"理解"图片等媒体资源， 也算是一个特别新兴的研究领域。 正巧大项目开始前期， 我也准备在博客里总结一下前几次作业里面涉及的概念， 感觉特别有趣和实用呢~

这一次尝试解决的问题是: 假如你希望有一幅风景的全景图(panaroma)，但是你手头上只有一堆关于该风景不同角度的图片， 怎么利用computer vision学习到的方法来合成一张全景图。

比如一个简单的例子， 家里的游泳池的照片你刚好有两张不同角度的图片(如下图), 通过计算两张图片中的feature points(特征点)并且进行匹配，得到相应空间转换的矩阵(homography)， 借此可以将不同的图片映射到同一个景观上进行叠加(stitching)， 来获取更全面的视角。

<img src="http://ww1.sinaimg.cn/large/006tNc79gw1f9k6ilaabuj30hg0eo76b.jpg" style="display: block; margin: 0 auto;">

在全景图中的应用如下图:

<img src="http://ww3.sinaimg.cn/large/006tNc79gw1f9k6mj1jw6j30qa0h0jv5.jpg" style="display: block; margin: 0 auto;">

这也是这篇博文希望最后完成的目标。



## Computer Vision

### 特征点提取

Image features是描述一张图像的重要特征之一。 很多情况下我们分辨不同的图片的直觉之一是利用边缘的分布和形状， 也是一开始利用edge detection来处理图像的缘由， 通过把image当作一个$m*n$的矩阵， 其中每个元素为灰度图片的pixel intensity， 利用filter(box, haar)等等来简化对相邻元素的求导过程， 来得出pixel intensity上的变化速度， 大多数情况下假设边界往往意味着pixel intensity的剧烈变化， 那么将处理后数值高的来进行local maximum suppression之后可能大致得到边界点。由此而来的应用是corner detection， 比如最典型的harris corner detection。通过边角(corner)来帮助识别图片。

利用corner来作为图片特征是一个初步的可实现的想法， 然后有一些固有的缺点， 比如尽管corner detection是rotation invariant的， 但是不scale invariant， 这意味着， 一张被放大过的图片， 之前曾经被识别为corner的点， 在新图片中就不被识别出来了。 原理如图：

<img src="http://ww4.sinaimg.cn/large/006tNc79gw1f9kfaxk3qqj311q0q4abj.jpg" style="display: block; margin: 0 auto;">

我们希望找到一些图片的特征， 这些特征不受旋转的干扰(rotation invariant)， 而且也不受放大缩小处理的干扰(scale invariant)。而这个也是SIFT(scale-invariant feature transform)算法所要解决的问题， 这也是这次全景组合的应用中我所用到的选取特征点的方式。 

大致的介绍下[SIFT](https://en.wikipedia.org/wiki/Scale-invariant_feature_transform)， 原理是利用Laplacian of Gaussian函数能够detect blob区域的特点， 根据不同的Gaussian sigma $\sigma$ 我们可以匹配到不同scale程度上的区域极值，而作者Lowe等人利用Difference of Guassian来替代具有相似函数属性的Laplacian of Gaussian， 从而提高计算速率(因为DoG是seperable的)， 通过这些处理， 可以得到在不同的locational and spatial都存在的local maximum， 也是我们所希望的到的特征点。

同时Lowe提出了将特征点描绘为一个向量的方式， 通过在其pixel区域附近的$16*16$的格间中， 收集每个$4*4$区域内关于image gradient的major magnitutude and orientation的信息形成一个histogram表， 大致分为8个bin, 从而得到的$4*4*8 = 128$维的向量作为该特征点的特征向量。

```matlab
% 利用开源的matlab library vl_sift 来完成特征向量的获取
I = imread('hotel/hotel-00.png');
[f,d] = vl_sift(single(I)) ;
```



### 特征点的匹配

在对应每一张图片分别经过SIFT等算法进行处理， 得到特征点和特征向量之后， 我们需要将这些特征点对应起来。 换句话说， 如果两张图片有特别多的相似的特征点， 我们可以以很大的机率说它们在描述同一个东西。 

而匹配特征向量的方法也很原始， 就是计算向量之间的距离， 如果在Eludiean distance上离得比较近的点， 我们认为可能比较相似。 同时为了降低误判的纪律， 我们还希望最接近的那个距离， 相比第二个接近的距离要小很多。 通过两个数值的比小于某个threshold可以来达到这个效果。

```matlab
% 同样利用vl_sift自带的matching函数， 来比较两张图片中特征向量的匹配
I = imread('hotel/hotel-00.png');
II = imread('hotel/hotel-01.png');
[f,d] = vl_sift(single(I)) ; 
[ff,dd] = vl_sift(single(II)) ;
[matches, scores] = vl_ubcmatch(d, dd, 5);
```

大致的结果如图：

<img src="http://ww3.sinaimg.cn/large/006tNc79gw1f9kg47w4mxj31em0jejyn.jpg" style="display: block; margin: 0 auto;">



### 空间转换矩阵

具体的分析将会在另一篇博文中仔细讨论， 大致的原理是， 利用得到的feature match， 我们可以近似得到图片经过的转换， 然后用矩阵来表示。

```matlab
% 通过计算homography矩阵， 将00中的特征点map到新的01图中
clear;
clc;
close all;
I = imread('hotel/hotel-00.png');
II = imread('hotel/hotel-01.png');
[f,d] = vl_sift(single(I)) ; 
[ff,dd] = vl_sift(single(II)) ;
[matches, scores] = vl_ubcmatch(d, dd, 100);

[~, matchid] = sort(scores);

matchid = matchid(1, 1:end);
matches = matches(:, matchid);
bestMatches = matches;

% these are matches.
pSrc = f(1:2, bestMatches(1, :));
pTgt = ff(1:2, bestMatches(2, :));

combs = [1 2 3 4]; % Use top 4 matches.
bestMatchesID = 1;

A = zeros(8, 9); % since for four matches, we have 8 rows.
for i=1:4
xi = pSrc(1, combs(bestMatchesID, i));
yi = pSrc(2, combs(bestMatchesID, i));
xiprime = pTgt(1, combs(bestMatchesID, i));
yiprime = pTgt(2, combs(bestMatchesID, i));

row1 = [xi yi 1 0 0 0 -(xiprime*xi) -(xiprime*yi) -xiprime];
row2 = [0 0 0 xi yi 1 -(yiprime*xi) -(yiprime*yi) -yiprime];
A((2*i-1):(2*i), :) = [row1; row2];
end

[V,D] = eig(A'*A);
h = reshape(V(:, 1), 3, 3);


X_hom=h'*[pSrc;ones(1,size(pSrc, 2))];  % be careful, Matlab has the matrix transposed
X_hom=X_hom./repmat(X_hom(3,:),[3,1]);
match_plot(I, II, pSrc', X_hom');
```

上面这段代码可以得到如下的结果， 其中我用到了`match_plot`这个函数[here](https://www.mathworks.com/matlabcentral/fileexchange/31144-match-plot)来实现更好的可视化效果， 也就是把这些点给连线起来。可以看到的是， 这些点经过mapping之后仍然可以指向相同的位置， 尽管两张是完全不同的图片。 这个也是我们实现全景图的一个基础。

<img src="http://ww3.sinaimg.cn/large/006tNc79gw1f9kg7usla1j30vs0c70y2.jpg" style="display: block; margin: 0 auto;">
<img src="http://ww3.sinaimg.cn/large/006y8lVagw1f9fvb3funyj30vs0c7wk6.jpg" style="display: block; margin: 0 auto;">
<img src="http://ww2.sinaimg.cn/large/006y8lVagw1f9fvbfrdxjj30vs0c7n2k.jpg" style="display: block; margin: 0 auto;">
<img src="http://ww3.sinaimg.cn/large/006y8lVagw1f9fvbmsvkqj30vs0c77aj.jpg" style="display: block; margin: 0 auto;">
<img src="http://ww4.sinaimg.cn/large/006y8lVagw1f9fvbs1gxuj30vs0c7dmk.jpg" style="display: block; margin: 0 auto;">
<img src="http://ww1.sinaimg.cn/large/006y8lVagw1f9fvbzq4w6j30vs0c7wkq.jpg" style="display: block; margin: 0 auto;">
<img src="http://ww1.sinaimg.cn/large/006y8lVagw1f9fvc7r1moj30vs0c7wk4.jpg" style="display: block; margin: 0 auto;">

如果假设每个图片都是一个矩形，我们希望将这些举行在空间中叠加起来： 

```matlab
% 其中compute_homography是上述得到homography矩阵的算法
clear;
clc;
close all;
I = imread('hotel/hotel-06.png');
II = imread('hotel/hotel-07.png');
[f,d] = vl_sift(single(I)) ; 
[ff,dd] = vl_sift(single(II)) ;
[matches, scores] = vl_ubcmatch(d, dd, 40);
[~, id] = sort(scores);
bestMatches = matches(:, id);

h0001 = compute_homography(0, 1, 140);
h0102 = compute_homography(1, 2, 99);
h0203 = compute_homography(2, 3, 30);
h0403 = compute_homography(4, 3, 140);
h0504 = compute_homography(5, 4, 204.7);
h0605 = compute_homography(6, 5, 140);
h0706 = compute_homography(7, 6, 160);

I00 = imread('hotel/hotel-00.png');
I01 = imread('hotel/hotel-01.png');
[imgh, imgw, ~] = size(I00);

x = [0 0 imgw imgw];
y = [0 imgh imgh 0];

I03 = [x;y];
I02Proj = projective_transform(h0203, x, y);

I01Proj = projective_transform(h0102, x, y);
I01Proj = projective_transform(h0203, I01Proj(1, :), I01Proj(2, :));

I00Proj = projective_transform(h0001, x, y);
I00Proj = projective_transform(h0102, I00Proj(1, :), I00Proj(2, :));
I00Proj = projective_transform(h0203, I00Proj(1, :), I00Proj(2, :));

I04Proj = projective_transform(h0403, x, y);

I05Proj = projective_transform(h0504, x, y);
I05Proj = projective_transform(h0403, I05Proj(1, :), I05Proj(2, :));

I06Proj = projective_transform(h0605, x, y);
I06Proj = projective_transform(h0504, I06Proj(1, :), I06Proj(2, :));
I06Proj = projective_transform(h0403, I06Proj(1, :), I06Proj(2, :));

I07Proj = projective_transform(h0706, x, y);
I07Proj = projective_transform(h0605, I07Proj(1, :), I07Proj(2, :));
I07Proj = projective_transform(h0504, I07Proj(1, :), I07Proj(2, :));
I07Proj = projective_transform(h0403, I07Proj(1, :), I07Proj(2, :));

figure;fill(x, y, 'r');hold on;
fill(I02Proj(1, :), I02Proj(2, :), 'g');
fill(I01Proj(1, :), I01Proj(2, :), 'b');
fill(I00Proj(1, :), I00Proj(2, :), 'y');
fill(I04Proj(1, :), I04Proj(2, :), 'k');
fill(I05Proj(1, :), I05Proj(2, :), 'w');
fill(I06Proj(1, :), I06Proj(2, :), 'c');
fill(I07Proj(1, :), I07Proj(2, :), 'm');

% projective_transform.m
function proj = projective_transform(h, x, y)
proj = h'*[[x;y];ones(1,size([x;y], 2))];  % be careful, Matlab has the matrix transposed
proj=proj./repmat(proj(3,:),[3,1]);
end
```

可以得到如下图所示的空间合集：

<img src="http://ww1.sinaimg.cn/large/006y8lVagw1f9fvop5ss7j30fk0bot9k.jpg" style="display: block; margin: 0 auto;">

最后将所有图片的pixel都map过去， 再稍微blend一下就可以得到完整的全景图了：

<img src="http://ww2.sinaimg.cn/large/006y8lVagw1f9fvst75ufj30zr0dq0ut.jpg" style="display: block; margin: 0 auto;">



## Reference

博文中部分图片示例来自课程slides [homography lecture slides](http://www.teach.cs.toronto.edu/~csc420h/fall/slides/lecture9.pdf)
