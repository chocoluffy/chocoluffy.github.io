title: 用ffmpeg从视频中获取图片及GIF
date: 2016-08-27 16:37:22
tags: [machine learning, 用户体验]
categories: 技术
---

最近的项目涉及比较多的视频和图片的处理， 发现了一个特别好用的linux library "ffmpeg"， 在其官网的介绍中可以发现的是convert\record\stream video和audio的功能， 但其实我只是利用这个工具来从视频中获取一张张单独的图片(frame)， 然后来做后续的机器学习(相似度匹配PCE， 人像识别等等)等处理。 

<!-- more -->

在项目的展示中， 我提出了来自youtube的启发， 我感觉也是最近这几周， youtube上的视频列表多了一个新功能是， 当你鼠标hover当前视频时， 静态图片会变成视频中其中的一段GIF， 然后过一段时间再变回来， 具体效果看这个动图：

当时上youtube就觉得用户体验好棒， 很快想到的一些问题是， youtube是随机攫取GIF的嘛， 是否这个GIF就是这个视频的重要scene， 是利用收集的社交数据和评论来预测重要性的， 还是仅仅通过比较frame出现的时长来比较......

这些都是很有趣的问题， 每一个方向展开来说都可以逐渐细分到实现的算法和数据格式。 我现在正在做的也正是我上面提到的其中一个方向哈哈， 而今天这篇博文想要探讨的， 是实现上面所有后续构想的building block， 怎样获取数据源和呈现。 ffmpeg和imagemagick这两个处理照片和视频特别方便的库也再这里介绍一下。

## Preparation

安装ffmpeg的方式很简单， 在OSX里面`brew install ffmpeg`就可以了。同理也有`brew install imagemagick`。

## Example

下面是各种working choice，ffmpeg强大的另外一个地方是它并不需要将整个视频都下载下来然后再进行处理， 而是可以直接read from stream。 而在整个流程最花时间的步骤其实并不是获取那个frame， 而是将frame根据一定编码保存到本地这个过程。 而后续如果有充分时间， 我也满希望可以仔细去看看ffmpeg编码的格式~

[1]`ffmpeg -y -i https://video.twimg.com/ext_tw_video/712057418646052864/pu/vid/1280x720/JiR-RnnRyfQVF5ue.mp4 -ss 3 -frames:v 1 frame_3.jpg`
can help extract the third frame from that url.

[2]`ffmpeg -y -i https://video.twimg.com/ext_tw_video/712057418646052864/pu/vid/1280x720/JiR-RnnRyfQVF5ue.mp4 -vf scale=320:-1 -r 10 -f image2pipe -vcodec ppm - | convert -delay 5 -loop 0 - gif:- | convert -layers Optimize - output.gif` 
will output images to convert them into gif.

[3]`ffmpeg -t 3 -ss 00:00:02 -i https://video.twimg.com/ext_tw_video/712057418646052864/pu/vid/1280x720/JiR-RnnRyfQVF5ue.mp4 middle.gif`
The snippet directs ffmpeg to create a GIF 3 seconds long starting at 2 seconds into the video.

[4]Thus, simply combine the [2] and [3] can convert some specific time frames into optimized gif like this `ffmpeg -t 3 -ss 00:00:02 -i https://video.twimg.com/ext_tw_video/712057418646052864/pu/vid/1280x720/JiR-RnnRyfQVF5ue.mp4  -vf scale=320:-1 -r 10 -f image2pipe -vcodec ppm - | convert -delay 5 -loop 0 - gif:- | convert -layers Optimize - output.gif`

[5]ffmpeg has its own version of converting to gif. `ffmpeg -t 3 -ss 1 -i https://video.twimg.com/ext_tw_video/712057418646052864/pu/vid/1280x720/JiR-RnnRyfQVF5ue.mp4 output.gif`. However, the file size is extremely large, hard to load.

For now, version [4] is the best choice.

`-ss`: follows a single number means extracting that single frame from video source; follows a specific time-format means extracting from that time. 

`-t`: follows a number means the duration of that extraction.

我在这里只记录了几个较为常用的parameter options。更多的option可以参看[官方文档](https://www.ffmpeg.org/ffmpeg.html)

## Dev Environment

接下来是一段我写的示例代码， 主要还是就怎么使用ffmpeg的问题稍微说一下， 毕竟大部分Machine Learning的工作还是在python里面写， 而当我们需要在python里面获取这些frames的时候， 我们应该怎么调用ffmpeg和imagemagick呢？

这里稍微补充一点， 启示ffmpeg本身也可以convert seperate images into gif， 但是相比与imagemagick还提供了图片压缩和优化的选项， 我更倾向于使用两者的结合。

### virtualenv

就使用ffmpeg这个方面本身并不需要提及virtualenv， 但是很多和ffmpeg相关的后续工作都会和很多python的scientific computing package一起合用， 而安装这些packages的过程是非常繁琐而容易出错的， 大家都习惯一上来就把这些library安装在全局， 而无论是安装过程还是未来的版本管理都是mess。

因此这里稍微提一下anaconda， 专为管理python packages而生的CLI， 为每一个项目创建一个virtualenv然后给那个项目安装不同的独立的python libraries， 用完即删。

`conda create --name <project-name> python=2.7 opencv matplotlib`, use conda to install library dependencies. Also specify the python version and library needed to pre-install, say inside this project, we want  `import cv2`, thus we put those libraries right after the python version. Then `source activate <project-name>` can jump into that virtualenv.

### subprocess

Since I will utilize "imagemagick" library to process images into gifs, by piping the results from "opencv", most likely I will need to create a subprocess to do that. The command-line way to achieve that is `ffmpeg -t 3 -ss 00:00:02 -i <video source> -vf scale=320:-1 -r 10 -f image2pipe -vcodec ppm - | convert -delay 5 -loop 0 - gif:- | convert -layers Optimize - output.gif`, which for example, will extract starting at 00:00:02 a 3-seconds short video from origin video and convert\optimize them into a smaller gif. In order to support multiple pipes as in command line, we use subprocess's `PIPE` functions to concatenate those different parts.

```python
def get_video_gif(video, t, duration, output_name):
    # In subprocess, save gif to local.
    # ffmpeg -t 3 -ss 00:00:02 -i https://video.twimg.com/ext_tw_video/712057418646052864/pu/vid/1280x720/JiR-RnnRyfQVF5ue.mp4 -vf scale=320:-1 -r 10 -f image2pipe -vcodec ppm - | convert -delay 5 -loop 0 - gif:- | convert -layers Optimize - output.gif
    p1 = sp.Popen(['ffmpeg', '-t', str(duration), '-ss', str(t), '-i', video, '-vf', 'scale=320:-1', '-r', '10', '-f', 'image2pipe', '-vcodec', 'ppm', '-', ], stdout=sp.PIPE)
    p2 = sp.Popen(['convert', '-delay', '5', '-loop', '0', '-', 'gif:-'], stdin=p1.stdout, stdout=sp.PIPE)
    p1.stdout.close()
    p3 = sp.Popen(['convert', '-layers', 'Optimize', '-', output_name], stdin=p2.stdout, stdout=sp.PIPE)
    p2.stdout.close()

    output = p3.communicate()[0]
```

## Documentation

- [How to convert a video to gif using ffmpeg](http://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality)
- [How to convert to and from between gif and video](https://davidwalsh.name/convert-video-gif)
- [use youtube-dl and ffmpeg to download](https://www.reddit.com/r/learnprogramming/comments/44nhzp/how_to_use_youtubedl_and_ffmpeg_to_download/)
- [how to process youtube video without downloading it](http://superuser.com/questions/680323/processing-youtube-video-in-ffmpeg) main idea is to config ffmpeg with `libquvi`!!
- [install ffmpeg through homebrew](https://trac.ffmpeg.org/wiki/CompilationGuide/MacOSX) with recommending configuration options like `brew install ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265`
- [[recommend]how to generate video preview with ffmpeg](https://www.binpress.com/tutorial/how-to-generate-video-previews-with-ffmpeg/138)
- [ffmpeg generate thumbnail from video](http://www.bogotobogo.com/FFMpeg/ffmpeg_thumbnails_select_scene_iframe.php) after generate the thumbnail and stitch together, here is a front end demo to over it [demo](http://jsfiddle.net/r6wz0nz6/2/) to see a preview.
- [some tricks of using youtube-dl](https://wideopenbokeh.com/AthenasFall/?p=5)

Inside `~/.bashrc`, set `alias youtubemp3='youtube-dl --extract-audio --audio-format mp3'` to be able to create a alias and save a youtube video to mp3.

So basically, `youtube-dl -F <url> ` to list all available video format, then  `youtube-dl -f 134 -o video.mp4 https://www.youtube.com/watch?v=v1uyQZNg2vE`


## Summary

处理视频和图片对我来说是一个蛮有趣的方向。 我们每天都会查询和搜索到无数多媒体信息， 而人们对信息的处理能力和标准也越来越严苛， 从简单文本到图片分享再到视频， 现在还很火的视频直播技术不是吗。 人们越来越多地被记录下来， 从曾经一生可能只去几次的影楼， 到情绪高涨时举起的自拍杆， 再到可能无时无刻都存在的直播和拍摄。

而记录本身， 就孕育着还原的渴望。

利用文字， 图片和视频， 科学家们能会如何重构一个曾经发生的世界， 而又能怎样地拿那个世界的统计和观察来预测下一个每分每秒。 深度学习和人工智能火了， 或许也是人们在尝试还原重构这个世界的一个必经之路， 很期待未来几年的科技发展啊。

很幸运以一个学生和实习生的身份慢慢进入这个殿堂。 话说回来， 每次见到那些用户体验特别好的细节总是特别喜欢然后絮絮叨叨呢哈哈~