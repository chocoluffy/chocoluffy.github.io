title: Ajax(with Jquery) on Nodejs server
date: 2016-02-20 14:37:25
tags: [javascript, nodejs]
categories: 技术
---

Nodejs的第一个上手小项目， 就是尝试自己在本地的页面来发送Ajax请求， 并且通过nodejs的json文件返回后以比较优雅的前端样式呈现出来。 算是再一次复习了Bootstrap， fontawesome库的调用， 以及一些jquery的语法。 仔细回想， 其实nodejs的后端开发和rails\django的router的本质都是一样的， 以前在还没有理解实质的时候就上手实战， 现在慢慢理解了才能够融会贯通， 现在的开发速度大大进步了。 同时也学会了如何允许CORS的请求， 和正则匹配的部分细节。
<!-- more -->

![project gif](https://zippy.gfycat.com/FancyWeeBrontosaurus.gif)


## Requirements

Requesting 127.0.0.1:3000 should give your index page (with CSS and JS). For the subsequent requests, you should use AJAX to send requests to the Node server and update only some parts of the page with the response data. Ideally, you should return JSON data as a response and then format that using Javascript.

## Ongoing notes

- how to use Ajax to request the data instead of using url request to node server? **_Main idea is that to use `$.getJSON("http://127.0.0.1:3000/favs.json", function(...){...}` to send out the Ajax request, and set the nodejs script to be able to respond such json file request and properly handle CORS problem. The things left will be just styling and formatted retrieved information and display._**

- nodejs. You might use Node.js to connect to a database (returning a result set from a query, say, or updating a record); deliver HTML, XML, or JSON content; connect to local files; or serve up static web pages like Apache or another web server.

- ajax. The mechanism for sending data to and retrieving data from the server with Ajax is the XMLHttpRequest object. So, now that we have an XMLHttpRequest object created, what do we do with it? We use it to make HTTP requests. To do so, we initialize the object with the open() method, which takes three arguments. Like `xmlhttp.open("GET","Demo.xml",true);`.
  - HEAD. `xmlhttp.open("HEAD","Demo",true);` and `xmlhttp.send(null)`.
  - GET. `xmlhttp.open("GET","Demo?FirstName=Nat&LastName=Dunn",true);`, the last argument is choose for true(asynchronous) or false(synchronous). The difference is that for synchronous version, browser has to wait for a response. The code below shows how to use Ajax solely to listen to the content change.

```

<script type="text/javascript">
    function start() {
        var xmlhttp = new XMLHttpRequest();
        var contentDiv = document.getElementById("Content");
 
        xmlhttp.open("GET", "Demo?FirstName=Nat&LastName=Dunn", true);
        xmlhttp.onreadystatechange = function() { // handle Ajax response.
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                contentDiv.innerHTML = xmlhttp.responseText;
            }
        }
        xmlhttp.send(null);
    }
 
    observeEvent(window, "load", function() {
        var btn = document.getElementById("btnStart");
        observeEvent(btn, "click", start);
    });
</script>
```

- Ajax in jquery. In general, Ajax does not work across domains. Exceptions are services that provide JSONP (JSON with Padding) support, which allow limited cross-domain functionality. JQuery provides Ajax support that abstracts away painful browser differences. It offers both a full-featured $.ajax() method, and simple convenience methods such as $.get(), $.getScript(), $.getJSON(), $.post(), and $.fn.load(). A working example of using Ajax of pulling image data from Flick referring [this post](http://www.w3school.com.cn/jquery/ajax_getjson.asp)

- How to avoid CORS(cross-origin resources sharing) error, refer to [this post](http://www.bennadel.com/blog/2327-cross-origin-resource-sharing-cors-ajax-requests-between-jquery-and-node-js.htm). **_Main idea is that at the nodejs server part, we allow some origin and some type of content being CORS, thus we can request such resources at client part, which in this case in my own browser._**

- How to regex all the href links inside a tweet? Especially how to do that in javascript? 

```
			  	// tweet here is a JSON object
			  	var tweetString = JSON.stringify(tweet);
			  	var regex = /(https?:\/\/.*?)("|\s)/g;
			  	var matchlst = [];
			  	tweetString.replace(regex, function(a, b, c, d){
			  		if(a.slice(-1)=='"'){
			  			a = a.slice(0, -1);
			  		}
			  		matchlst.push(a);
			  	})
```

**_Main idea is that we first make a JSON object into a string, then we can do regex match on a string. we use //g to indicate that it is search globally. And then for those valid match, we trim out the trailing quote then store it into a list for later formatting use. _**. Note that we should make full use of the flag option provided with regex matching, refer to [this post](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions). For example, `/.../g` is for global match, `/.../i` is for case-insensitive match.

- How to use Jquery to construct `div` or `a` elements? refer to [this post](http://stackoverflow.com/questions/867916/creating-a-div-element-in-jquery), simply do the following: **_Here I make use of the Bootstrap alert styling!_**

```
$("<div>").addClass('alert alert-warning').html("<strong>Warning!</strong> Such user or tweet does not exist. Please enter a valid query.").prependTo(query_list);
```

- Avoid the `submit` event cause a page redirection or refresh? simply add a `return false` at the end of the submit function. Here is the submit function I wrote to process the info after AJAX from nodejs server. Note that my nodejs server host at `http://127.0.0.1:3000/`.

```
$("#queryform").submit(function(){
    		emptyAll();
    		var searchval = $("#search").val();
    		console.log(searchval);
    		$("#list ul").addClass("unseen");
    		var query_list = $("#query");
    		var nameHash = {};
    		var tweetidHash = {}; 
	    	$.getJSON("http://127.0.0.1:3000/favs.json", function(tweets){
				$.each(tweets, function(i,tweet){
					nameHash[tweet.user.screen_name] = tweet;
					tweetidHash[tweet.id_str] = tweet;
				});
				if(Object.keys(nameHash).indexOf(searchval)>=0){
					var formattedText = "<strong>User screen name: </strong>";
					formattedText += searchval + "<br>";
					formattedText += "<strong>Tweet: </strong><br>";
					formattedText += "<pre><code>" + JSON.stringify(nameHash[searchval], null, 4) + "</code></pre>";
					$("<p>").html(formattedText).prependTo(query_list);
				}
				else if(Object.keys(tweetidHash).indexOf(searchval)>=0){
					var formattedText = "<strong>Tweet ID: </strong>";
					formattedText += searchval + "<br>";
					formattedText += "<strong>Tweet: </strong><br>";
					formattedText += "<pre><code>" + JSON.stringify(tweetidHash[searchval], null, 4) + "</code></pre>";
					$("<p>").html(formattedText).prependTo(query_list);
				}
				else{		
					$("<div>").addClass('alert alert-warning').html("<strong>Warning!</strong> Such user or tweet does not exist. Please enter a valid query.").prependTo(query_list);

				}
			});
	
			$("#query").removeClass("unseen");
			$("#query").addClass("seen"); 
			return false; 
    	});
```

- Some JS tricks:
  - `if...in...` equivalent type in JS as in python. use `Array.indexOf(element)>=0` to know that if such element exist in this array.
  - Get the keys array of a Hash. `Object.keys(hash)`.
  - Get the last character from a string. `string.slice(-1)`.
  - Trim out the last character from a string. `string = string.slice(0, -1)`.
  - Use Jquery to get the value from submitted form. 



