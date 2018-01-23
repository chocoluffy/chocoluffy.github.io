title: AWS elastic beanstalk使用体验
date: 2016-05-04 21:03:58
tags: [javascript, nodejs, AWS]
categories: 技术
---

本文对目前市面上的主流Paas(platform as a service)提供商进行了比较， 比如heroku和amazon家的新星elastic beanstalk。并以一个nodejs爬虫的实例部署在了eb的服务器上。很多关于服务器端的概念也因此理清了， 比如reverse proxy server, dynamic IP addressing和后端的一些配置。也在文章中做个小结， 分享给感兴趣的大家。

<!-- more -->

<div style='text-align:center' markdown='1'>![aws](http://ac-TC2Vc5Tu.clouddn.com/de08e7610183200c.png)</div>

## 概览

将之前用nodejs写的对[cnode社区精华帖](<https://cnodejs.org/?tab=good>)的爬虫放在AWS的EC2 instance下管理， 利用elastic beanstalk来对AWS资源进行分配和调控， 由于使用的还是free-tier的single instance， 则elastic beanstalk所特有的load-balancing的优势没有办法享受到。

<div style='text-align:center' markdown='1'>![ebean](http://ac-TC2Vc5Tu.clouddn.com/69662ed94ae1f3ff.png)</div>

一开始如果直接按照AWS给的方法, `eb init`初始化一个elastic beanstalk的项目， `eb create`创建一个environment和一个EC2实例, 然后`eb deploy`将.git里面committed的改动push到elastic beanstalk的生产环境里面， 然后用`eb open`来打开这个IP address， 如果之后需要终止这个app的话， 就`eb terminate`就好了。

<div style='text-align:center' markdown='1'>![heroku](http://ac-TC2Vc5Tu.clouddn.com/143c21d61cd3cf33.png)</div>

如果之前有使用heroku的经验的话， 其实你会发现其实amazon elastic beanstalk和heroku提供的服务非常相似， 实际上， 就这两家服务的定位而言， 都是platform as a service（Paas）， 也就是让developer可以将网站， 移动端部署在云端(cloud)不需要顾虑backend server和database的configuration。 而heroku本身相对于其他市面上的Paas在auto-scaling上做得更加出色， 它的computing resources(dyno)可以按照计算的需求而叠加从而满足在高流量下的网站后端流畅运行。而近几年amazon的elastic beanstalk的出现， 在这个Paas的市场给我们developer多一个很好的选择。就自己的使用而言， 感觉两者的command line interface其实设计得差不多， 都很简洁方便， 不过相比heroku， amazon的AWS还涉及租用到计算单元EC2, 就配置的操作来说， 你在配置AWS的服务上需要花更多的时间去设置环境变量和考虑密钥存储， 毕竟你可能有时候有ssh远程登陆amazon linux服务器的需求。相比之下， heroku的配置就是很简单的在`~/.bashrc`文件里面添加toolbelt文件夹的路径了。

>  其实heroku它本身就是deploy在了AWS上的呀😂， 所以理论上在performance上不会有太大的差别。

而在pricing上， 我认为AWS的价格和服务会更加的实惠， 毕竟考虑到你有一张信用卡就可以申请到你一年的free-tier的single instance的使用权利， 而single instance对一些小型的side project来说完完全全是够用的呀。即便不够用， 换成large instance也是several clicks away， 反正也是按用量收费， 经济实惠!

## 遇到的问题

第一个使用EB部署的应用是一个nodejs爬虫， 负责爬去cnode社区的精华帖， 然后返回一个json object收集精华帖的link, 标题和作者avatar， 为了显示的直观， 我并没有写前端的样式， 而是直接`JSON.stringify(json)`然后send会浏览器。之后如果仅仅作为REST API使用的话， 还需要在router上修饰一下URL。目前还是有点粗糙的。[github链接](https://github.com/AirLoft/web-scraper)

<div style='text-align:center' markdown='1'>![demo](http://ac-TC2Vc5Tu.clouddn.com/9fd7dd3d203d2d91.png)</div>

一开始我直接将在本地localhost运行的版本deploy到了elastic beanstalk上， 由于缺少了这一行配置`var port = process.env.PORT || 3000;`， 我直接把port定在了3000， 而elastic beanstalk是有应该占用的port的， 所以得到了“502 bad gateway error”。

还有一点需要注意的是`npm start`这个npm script里面的配置， AWS elastic beanstalk会找到这条指令并去执行来执行相应的js文件， 比如我把写cnode网站的爬虫写在了cnode.js里面， 那么我需要

```js
  "scripts": {
    "start": "node cnode.js"
  },
```

来保证服务器执行的是我对cnode这个网站的爬虫。



## Q&A

以下内容是我在自己折腾Elastic Beanstalk的时候收集的一些比较简练而准确的总结， 在这里分享给大家。 其实amazon的AWS教程写得非常详细的， 大家自己如果有能力最好去尝试自己阅读和实践它给的例子!

**How elastic beanstalk works?**
Now you have a web app running in AWS Elastic Beanstalk. As Elastic Beanstalk creates your environment, it **interacts with several other AWS services** to create the resources required to run your web app securely and resiliently.

**How EC2 instance works?**
EC2 instance – A virtual machine that runs Amazon Linux or Microsoft Windows Server and that is configured to run web apps on the platform that you choose.
Each platform runs a different set of software, configuration files, and scripts to support a specific language version, framework, web container, or combination thereof. Most platforms **use either Apache or nginx as a reverse proxy** that sits in front of your web app, forwards requests to it, serves static assets, and generates access and error logs.

**What is reverse proxy server?**
A proxy server is a go-between or intermediary server that forwards requests for content from multiple clients to different servers across the Internet. A reverse proxy server is a type of proxy server that typically **sits behind the firewall in a private network** and directs client requests to the appropriate backend server. A reverse proxy provides an additional level of abstraction and control to ensure the smooth flow of network traffic between clients and servers.

Common uses for a reverse proxy server include:

- Load balancing – A reverse proxy server can act as a “traffic cop,” sitting in front of your backend servers and distributing client requests across a group of servers in a manner that maximizes speed and capacity utilization while ensuring no one server is overloaded, which can degrade performance. If a server goes down, the load balancer redirects traffic to the remaining online servers.
- Web acceleration – Reverse proxies can compress inbound and outbound data, as well as cache commonly requested content, both of which speed up the flow of traffic between clients and servers. They can also perform additional tasks such as SSL encryption to take load off of your web servers, thereby boosting their performance.
- Security and anonymity – By intercepting requests headed for your backend servers, a reverse proxy server protects their identities and acts as an additional defense against security attacks. It also ensures that multiple servers can be accessed from a single record locator or URL regardless of the structure of your local area network.

**What is amazon s3 bucket?**
Amazon S3 bucket – A storage location for your source code, logs, and other artifacts that are created when you use Elastic Beanstalk.

**How your domain will look like?**
Domain name – A domain name that routes to your web app in the form subdomain.region.elasticbeanstalk.com.

**When should I use AWS Lambda versus Amazon EC2?**

Amazon Web Services offers a set of compute services to meet a range of needs.

Amazon EC2 offers flexibility, with a wide range of instance types and the option to customize the operating system, network and security settings, and the entire software stack, allowing you to easily move existing applications to the cloud. With Amazon EC2 you are responsible for provisioning capacity, monitoring fleet health and performance, and designing for fault tolerance and scalability. AWS Elastic Beanstalk offers an easy-to-use service for deploying and scaling web applications in which you retain ownership and full control over the underlying EC2 instances. Amazon EC2 Container Service is a scalable management service that supports Docker containers and allows you to easily run distributed applications on a managed cluster of Amazon EC2 instances.
AWS Lambda makes it easy to execute code in response to events, such as changes to Amazon S3 buckets, updates to an Amazon DynamoDB table, or custom events generated by your applications or devices. With Lambda you do not have to provision your own instances; Lambda performs all the operational and administrative activities on your behalf, including capacity provisioning, monitoring fleet health, applying security patches to the underlying compute resources, deploying your code, running a web service front end, and monitoring and logging your code. AWS Lambda provides easy scaling and high availability to your code without additional effort on your part.

**To create a hosted zone in Amazon Route 53**

- Open the Amazon Route 53 management console.
- Choose Hosted Zones.
- Choose Create Hosted Zone.

For Domain Name, type the domain name that you own. For example: example.com.

Choose Create.

Next, add a CNAME record to the hosted zone. A CNAME record registers a domain name that you own as an alias of your web app environment's elasticbeanstalk.com subdomain.

When an Amazon Route 53 DNS server receives a name request for your custom domain name, it resolves to the elasticbeanstalk.com subdomain, which resolves to the public DNS name of your Elastic Load Balancing load balancer, which resolves to your web app's IP address.

Note
In a single-instance environment, the elasticbeanstalk.com subdomain resolves to an Elastic IP address attached to the instance running your web app.

**关于elastic beanstalk的价格**
有小伙伴在comment里面提问， 如果用完了一年的free-tier的话， 价格怎么计算呢? 可以参考下amazon的[这篇介绍](https://aws.amazon.com/elasticbeanstalk/pricing/)里面详细记录了EC2, S3, DB等等AWS相关服务的价格。如果是个人的side project, 对CPU和图片等用户信息存储的需求不是特别大的话， 免费的plan或者是micro的instance是完全够用的， 如果是在某方面的需求特别大， 比如说unsplash这个高清摄影图片分享的社区。

![unsplash](http://ac-TC2Vc5Tu.clouddn.com/bb0b5ef1d0298d11.png)

 unsplash将用户上传的照片存储在Amazon的S3服务上会比较安全和便捷，(搭配着Imgix这个service使用)， 具体的网站花销可以参考[这篇博文](http://backstage.crew.co/what-does-unsplash-cost/)， 里面记录了unsplash一个月网站使用的各种服务的明细记录， 也可以给一些希望做图片分享社区的创业者们一个参考。一个值得注意的点是， unsplash的花销是比较适合借鉴的， 因为unsplash和目前许多的创业公司一样， 选择将自己的主服务host在heroku这个平台， 选择S3等等主流的服务， 不像一些更geeky的公司可能为了省钱就自己来搭建和管理自己的服务器和数据库。 当然， 管理成本和维护成本都要考虑进去， 所以综上我才认为unsplash的例子是非常值得借鉴的!

## 参考链接

下面的链接是我在自己尝试搭建环境时参考的内容， 以及我选择free-tier的configuration的页面。其中就有以express为例子的服务端环境搭建。

- [setting up EC2 cli on mac](http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html#set_aes_home_linux) we store EC2 api tool, aws-access-key and aws-secret-key in `~/.bashrc`, so that we can use the shortcut commands to do `init\create\deploy\open`. The common commands are listed as followed.

```bash
eb init
eb create
eb deploy
eb open
```
- [A high level explanation of what EB does and what can we config](https://docs.aws.amazon.com/quickstarts/latest/webapp/welcome.html) trying to give a high-level description of what is the use and purpost of each AWS service, including EC2, the reverse proxy server sitting in front of servers, router 53 and so on so forth.
- [A detailed explanation of how to host an express app on EB full-step tutorial](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_nodejs_express.html) The tutorial uses an express app to explain how to use EB.
- [How to deploy a nodejs project to EB](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_nodejs.html) similar to the previous tutorial post.
- [how to connect to EC2 instance using ssh](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
by using `ec2-describe-instances`, we can get the id of my instance.

So after we have created an project, we go to the elastic beanstalk console, we will see the dashboard of all the application I host on EB such as the recent one(webscraper). The following is a screen capture of the configuration of that application on EB as in a free-tier plan:
![configuration](http://ac-TC2Vc5Tu.clouddn.com/7c3a33a6cfab0843.png) In this page, we can set the scaling option from single instance to load-balanced configuration, and when we add a load-balancer, it will automatically adjust the number of instances depending on the need.

When you turn on load balancing, Elastic Beanstalk creates a load balancer, deletes the Elastic IP address from your environment, and provisions a new EC2 instance. Elastic Beanstalk also updates DNS records to point the web app's domain name to the load balancer instead of to the IP address of a single instance.
