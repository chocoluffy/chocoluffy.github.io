title: socket.io开发多人聊天室教程
date: 2016-05-23 22:43:41
categories: 技术
tags: 
	- nodejs
	- web design
	- AWS
---

用socket.io搭配express写的一个多人聊天室应用， 同时借这个机会复习了一下socket及TCP/IP的一些细节知识， 在UI上用jquery， 简洁而快速地完成一些基础前端样式的开发， 开发时用nodemon和browser-sync来辅助开发流程。[在线Demo-网页版](http://52.20.64.23/chatroom), [github源代码](https://github.com/chocoluffy/chatroom), 欢迎提交bug issue或者pull request~

<!-- more -->


## 什么是socket?

socket是对TCP/IP协议的封装， 本身是一个调用接口， 也就是我们常说的API， 用socket可以让程序员更方便的使用TCP/IP协议而已。 

在学习C语言(csc209)的时候大家接触到的socket的接口函数比如`create/listen/connect/accept/send/read/write`， 实际上正是针对TCP编程的接口， 在课程里我们用C语言来实现TCP最基础的一个socket链接， 监听， 包括server-client之间的通信，同样的， socket这个调用接口也可以用java, python和nodejs任何后端语言来实现， 也会出现在各种各样需要服务器端和客户端通信的应用中。

而什么是TCP呢？

Transmission Control Protocol (TCP) 就是其中发送文本信息的**规则规范**而已。 TCP依赖更底层的函数实现来在网络上传输binary data。 这里和大家介绍telnet\putty这些利用TCP在command line上帮助你发送和接受纯文本消息的应用， 你可以利用telnet来， 比如， 发送消息到google.com：`telnet google.com 80` 在端口80连接到google.com(80默认给网络请求)。我们当然不会随便发文本消息给google.com， 因为我们知道google.com不会接受随意的， 没有结构的文本请求。 是的， 我们需要一个**标准(protocol)**来规范交流的方式。我们在浏览器输出http://google.com， 这意味着：

- 在port 80用TCP协议连接google.com的服务器。
- 请求返回资源“／”（默认资源）。
- 将请求用http（hypertext transfer protocol）的形式来规范。

## 什么是socket.io?

"Socket.IO goes a step beyond just providing an easy-to-use and more robust API on top
of web sockets. It also provides the ability to seamlessly use other real-time protocols if WebSockets are not available. For example, it will fall back on JSON long polling in the absence of WebSocket support." from Rohit Rai

简单来说，socket.io来socket本身的接口函数上再抽象了一层， 让程序员可以专注应用逻辑的开发， 而由socket.io来操作底层的函数调用和优化， 比如有些时候， 由于浏览器的原因不能使用web socket时， 可以默认用long polling来达到同样的效果。

在socket.io出现之前，我们会采用很多的hack来解决一个问题：**怎样在server和client端更有效率地双向传递信息？**比如上文提到的long polling,  client端发送XHR请求， 然后在server端挂住， 直到server收到数据， 就回传数据， 还是比较常见的hack。

直到HTML5的大规模使用， 出现了两种从服务器端推送数据到客户端的新方法， 一个是Server-Sent Events (SSE)， 另一个是今天的主角， 支持双向通信的WebSockets.

## 怎么用socket.io?

### http模块实现

下面用一个简单的例子来说明socket的使用， 很明确， 在服务器段当有新的连接的时候， 向客户端发送一个"greeting-from-server"的消息， 同时还监听客户端发来的"greeting-from-client"的事件，将消息打印在console里面。 

```js
// plain http's version of server.js
var http = require('http');
	socketIO = require('socket.io');
	fs = require('fs');

// if using express framework, we can define router easier!
var server = http.createServer(function(req, res){
	fs.readFile(__dirname + '/index.html', function(err, data){
		res.writeHead(200);
		res.end(data);
	});
});

// The above code is used for create a server to serve the static index.html file under the current directory. The following part is the main idea of how to use socket.io to construct and listen to events.
server.listen(3000);
console.log('listen on http://localhost:3000');

io = socketIO(server);

io.on('connection', function(socket){
	socket.emit('greeting-from-server', {
		greeting: 'Hello client!'
	});

	socket.on('greeting-from-client', function(msg){
		console.log(msg);
	});
});

```

```html
<!-- client side index.html  -->
<!DOCTYPE html>
<html>
    <head>
    </head>
    <body>
        <script src="/socket.io/socket.io.js"></script>
        <script>
            var socket = io('http://localhost:3000');
            socket.on('greeting-from-server', function (message) {
                document.body.appendChild(
                    document.createTextNode(message.greeting)
                );
                socket.emit('greeting-from-client', {
                    greeting: 'Hello Server'
                });
            });
        </script>
    </body>
</html>

```

代码很简洁。以上是用node原生的http模块来搭建的本地服务器， 还可以尝试使用express这个最负盛名的node框架之一来重新实现一下相同的逻辑。

### Express模块实现

```js
// express's version of server.js
var express = require('express'),
    app = express(),
    http = require('http'),
    socketIO = require('socket.io'),
    server, io;

app.get('/', function (req, res) {
  res.sendFile(__dirname + '/index.html');
});

server = http.Server(app);
server.listen(5000);
io = socketIO(server);

io.on('connection', function (socket) {
  socket.emit('greeting-from-server', {
      greeting: 'Hello Client'
  });
  
  socket.on('greeting-from-client', function (message) {
    console.log(message);
  });
});
```

> Express is a collection of HTTP utilities and middleware that make it easier to use Node as a web server.

用`var app = express()`来创建一个Express应用，将这个Express app当作第一个参数传入HTTP模块得到本地的简易服务器，we told Node that we wanted to use Express as our handler for HTTP requests. 而这个服务器的作用是在接收到对“／”默认资源的请求时， 将index.html文件传回给客户端，也就是我们的浏览器上显示出内容。

Next, we passed the HTTP server directly to the SocketIO method exactly as we would have if we were using a nonExpress HTTP server. Socket.IO took the server instance to listen for new socket connections on it. 

其中一个小细节：用 `emit` 来传输named message, 用 `send` 来传输a message without name.

## 多人在线聊天室

下面是对以上应用的一个简单拓展。使用一个轮播(broadcasting)的方式， 将客户端传来的消息显示给每一个在线的用户。

[github源代码	](https://github.com/chocoluffy/chatroom)

[在线Demo-网页版](http://52.20.64.23/chatroom)

在手机上也是可以用的， 不过UI没有专门针对移动端优化， 会有点糗的感觉😭。有bug汇报到Issue呀， 谢谢~

### 效果图Demo:

[1] pick a nickname:

[2] chatroom initialization:

[3] multi users chatting(one in chrome, another in safari):

### server端源代码

```js
// A fragment of server.js
var port = process.env.PORT || 3000;
server.listen(port);
console.log('listen on ' + port);

var io = socketIO(server);
var sockets = [];
var ID2user = {}; // username 

io.on('connection', function(socket){
	sockets.push(socket);
	
	var updateUserNum = function(skt){
		var people = sockets.length === 1 ? 'person' : 'people';
		skt.emit('greeting-from-server', {
			greeting: 'Welcome! ' + sockets.length + ' ' + people + ' online now!'
		});
	};

	updateUserNum(socket);

	// boardcast?!
	socket.on('message', function(message){
		var userlistChanged = false;
		if(!ID2user[socket.id]){ // if new user comes in.
			var profile = {
				username: message.username,
				avatar: message.avatar
			};
			ID2user[socket.id] = profile;
			userlistChanged = true;
		}
		for(var i=0; i < sockets.length; i++){
			sockets[i].emit('message', message);
			if(userlistChanged){ // update userlist when new user comes in.
				console.log(ID2user[socket.id].username + '(id: ' + socket.id + ' )' + 'joins!');
				sockets[i].emit('userlist', ID2user);
				updateUserNum(sockets[i]);
			}
		}
	});

	socket.on('disconnect', function(){
		for(var i=0; i<sockets.length; i++){
			if(sockets[i].id === socket.id){
				sockets.splice(i, 1);
			}
		}
		var usernameOut = ID2user[socket.id].username;
		delete ID2user[socket.id]; // remove user from online users.
		// send to client an updated userlist.
		for(var i=0; i < sockets.length; i++){
			console.log(usernameOut + '(id: ' + socket.id + ' )' + 'leaves...');
			sockets[i].emit('userlist', ID2user);
			updateUserNum(sockets[i]);
		}
		console.log("There are " + sockets.length + " active sockets remaining.");
	});
});
```

由于我们需要将这个应用放在服务器上看效果， 所以port number就不能一直是本地的localhost了， 需要改成`var port = process.env.PORT || 3000;`。

### 达到的效果

- 显示同时在线的人数和user list。根据你自己选的nickname在user list上显示。
- 每当有人加入或者disconnect的时候，更新所有客户端的user list。同时console都会有记录。
- 每当有客户端发送消息的时候， broadcasting给所有在线用户。

### TODOs

- local cache most frequent online users, to make the message transfer much much more efficient and effective. 
- support image transfer, which should be quite similar to text message, but rather using binary image data. 
- introduce animation!! this part should be quite familiar to me but I's just being lazy......
- social media ;)

### client端源代码

下面是部分client端的代码：由于监听了一些事件（毕竟我还是调整了前端的😂）, 所以代码有点长， 下面只显示核心部分：

```html
// part of index.html's script
var socket = io();
socket.on('connect', function(){

    // ... some codes here ...

	socket.on('greeting-from-server', function(msg){
		$('#greeting').empty();
		$('<div></div>').addClass('headline').text(msg.greeting).appendTo($('#greeting'));
	})

    // MAIN IDEA: if message comes, append to right place, and self adjust the view!
	socket.on('message', function(msg){

		var container = $('<div></div>').attr('id', 'container');
		var bubble = $('<div></div>').addClass('talk-bubble tri-right left-in border');
		var textWrapper = $('<div></div>').addClass('talktext').appendTo(bubble);
		$('<p></p>').html(msg.messageText).appendTo(textWrapper);

		// append the jquery clone to target destination.
		var nameClone = username2jqy(msg.username);
		var avaClone = avatar2jqy(msg.avatar);

		avaClone.appendTo(container);
		nameClone.appendTo(container);
		bubble.clone().appendTo(container);
		container.clone().appendTo($('#messages'));

		$('<br>').appendTo($('#messages'));

		// self-adjust scrolling height.
		var msgWrapper = document.getElementById('messages');
		msgWrapper.scrollTop = msgWrapper.scrollHeight;
	});

    // MAIN IDEA: when user list need to update, do it!
	socket.on('userlist', function(userlist){
		$('#userlist').empty();
		$('<h2></h2>').text('Online users:').appendTo($('#userlist'));
		Object.keys(userlist).map(function(d){
			var usrImg = $('<img></img>').attr('src', userlist[d].avatar);
			var usrName = $('<div></div>').text(userlist[d].username).addClass('listname');
			var profileWrapper = $('<div></div>').addClass('userlistProfile');
			usrImg.appendTo(profileWrapper);
			usrName.appendTo(profileWrapper);
			profileWrapper.appendTo($('#userlist'));
		})
	});

});
```

## 背景知识补充

完成一个小demo的开发同样会需要很多边角料信息的补充， 没有人会记得所有javascript各种处理对象的函数， 也没有人需要记得。留个note给自己， 也再以后查纠的之后方便回忆。

- [微信,QQ这类IM app怎么做——谈谈Websocket](http://ios.jobbole.com/85230/)
- [A Simple Introduction To Computer Networking](http://betterexplained.com/articles/a-simple-introduction-to-computer-networking/)
- `array.splice(i, 1);` will remove one item from ith index in that array, namely, in this case, remove the ith item from array.
- `docuemnt.createTextNode(string) \ document.createElement('div'); \  document.getElementById('SOMEID').appendChild(element); ` are some common DOM objects munipulations example.
- refer to this post: [send message by pressing enter](http://stackoverflow.com/questions/8894226/javascript-submit-textbox-on-enter), by adding an eventlistener function to message-box, we listent on the keyCode we press, if it is 13(Enter key), then we trigger the message send function.
- refer to this post: [styling for chat bubble](http://codepen.io/Founts/pen/gmhcl)
- Know how to create DOM elements in jquery: `$('<div></div>').addClass('headline').html(msg).appendTo($('#greeting'));`
- create modal in a visually good-looking way, refer to this post: [jquery.modal.js](https://github.com/kylefox/jquery-modal)
- add user a good-looking avatar! [adorable avatar!](https://github.com/adorableio/avatars-api)
- change html input focus, refer to this post: [html input focus](https://api.jquery.com/focus/)
- auto-adjust the scrolling top to the latest message, refer to this post: [srollTop = scrollHeight](http://stackoverflow.com/questions/15432691/css-overflow-value-for-chat)