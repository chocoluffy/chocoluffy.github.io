title: Angular入门-module和service
date: 2016-05-12 22:43:51
tags: [javascript, angularjs]
categories: 技术
---

自己学习angular时候记录的学习笔记，这一篇主要讨论module和service。

<!-- more -->


## How to define a module?

```javascript
// define a module
angular.module('notesApp',
    ['notesApp.ui', 'thirdCompany.fusioncharts']);

// look up a module.
angular.module('notesApp');
```

Also, make sure the file that defines the module is loaded first.

After defining the module, we use Angular to use these modules to bootstrap the application. `ng-app` takes an optional argument, the name of the modulr to load.

```html
<html ng-app="notesApp">
   <head>
     <title>Hello AngularJS</title>
    </head>
<body>
      Hello { { 1 + 1 } }nd time AngularJS
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.19/angular.js">
</script>
<script type="text/javascript">
angular.module('notesApp', []); </script>
</body>
</html>
```


## Controller in Angular

- fetching data from server to UI.
- presentation logic.
- user interaction, what will happen when user clicks something. 

An AngularJS controller is almost always directly linked to a view or HTML. We will **never have a controller that is not used in the UI** (that kind of business logic goes into services).

### HTML code

```html
<script type="text/javascript">
angular.module('notesApp', []) .controller('MainCtrl', [function() {
          // Controller-specific code goes here
          console.log('MainCtrl has been created');
        }]);
</script>
```

The above code define a module that depends on nothing, and a controller and its dependencies in the second argument, an array(the last argument in that array is the actual function itself).

We also introduce a new directive, ng-controller. This is used to tell AngularJS to go instantiate an instance of the controller with the given name, and attach it to the DOM element. In this case, it would load MainCtrl, which would end up printing the console.log() statement.

### Angular code

```
<html ng-app="notesApp"> 
<head>
  <title>Notes App</title>
</head>
<body ng-controller="MainCtrl as ctrl">
      { { ctrl.helloMsg } } AngularJS.
      <br/>
      { { ctrl.goodbyeMsg } } AngularJS
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.19/angular.js">
</script>
<script type="text/javascript">
angular.module('notesApp', [])
  .controller('MainCtrl', [function() {
    this.helloMsg = 'Hello ';
    var goodbyeMsg = 'Goodbye ';
    }
  ]
);
</script>
</body>
</html>
```

The reason why it only shows the the hello message it that: We **defined the variable helloMsg on the controller’s instance** (using the "this" keyword, and it is how we expose the data from controller to front-end UI), and the variable goodbyeMsg as a local inner variable in the controller’s in‐ stance (using the var keyword).

By using `ng-controller`, it allows us to associate an instance of controller with a UI element, in this case, the <body> tag.

"This" in javascipt, since it will be easily modified by whoever call the function, which causes the case that "this" inside and outside the function(the asychcronous function) may refer to two different objects. Thus, using a proxy variable will help!! Since with the help of the closure, that proxy varibale will always stay the same(pointing to "this") inside the function.

```html
<div ng-repeat="note in ctrl.notes">
<span class="label"> { { note.label } }</span>
<span class="status" ng-bind="note.done"></span>
</div>
```

The two methods appear above are the same effect, but we recommend the second way, since the second one will be replaced before the the first one. 

## Angular's working flow

After the entire HTML is loaded, angular.js starts to find the `ng-app` directive, then using that directive, it looks for the angular modules defined and attached to that DOM element. 

Then it starts to find other directive and binding elements inside the range. Every it meets `ng-controller` or `ng-repeat`, it creates a scope for that part of element. **scopr is the context of that element**, and it dictates what each DOM has access to in terms of functions, variables and so on.

Angular also adds **watcher and listeners** on HTML's DOM element.

The way angular update the UI, only happens for a certain events including XHR, server calls, page loads and user interaction such clicks and type.

### what is XHR?

XMLHttpRequest (XHR) is an API available to web browser scripting languages such as JavaScript. It is used to send HTTP or HTTPS requests to a web server and load the server response data back into the script.

Data from the response can be used to alter the current document in the browser window without loading a new web page, and despite the name of the API, this data can be in the form of not only XML, but also JSON, HTML or plain text.

Ajax depends heavily on XHR.

## More directive

```html
<div ng-repeat="note in ctrl.notes" ng-class="ctrl.getNoteClass(note.done)">
  <span class="label"> { { note.label } }</span>
  <span class="assignee" ng-show="note.assignee" ng-bind="note.assignee"></span>
</div>
```

```javascript
self.getNoteClass = function(status) { 
  return {
    done: status,
    pending: !status
  };
};
```

`ng-show` and `ng-hide` can help display or hide the DOM element. `ng-class` will add class to DOM element depending on the [1] if it is string [2] it is a json object, assign the key by the value of that key. `ng-switch on="<some variable value in scopr>"` with `ng-switch-when="<the conditional value of that variable>"` will create the if-else effect directly in html.

## Testing in Angularjs

### Test Runner Versus Testing Framework

We have often noticed that developers can sometimes get confused between the test runner and the testing framework. This could be because the same library often handles both responsibilities.

When working with JS (and AngularJS), we have two separate tools/ libraries for each purpose. Karma, which is the test runner, is solely responsible for finding all the unit tests in our codebase, opening browsers, running the tests in them, and capturing results. It does not care what language or framework we use for writing the tests; it sim‐ ply runs them.

Jasmine is the testing framework we will use. Jasmine defines the syntax with which we write our tests, the APIs, and the way we write our assertions. It is possible to not use Jasmine, and instead use something like mocha or some other framework to write tests for AngularJS.

## Model in angular

The `ng-bind` and "{ {  } }" we see in the above example demonstrates the one-way data-binding in angular, to use two-way data-binding, we opt for `ng-model`. As expected, such functionality is heavily used in user form.

## Angular's service

service refers to reuseable api that can be shared across the applications. One obvious difference between controllers and services is **services are independent of views**, while controllers drives UI.  

### Dependency injection

**Dependency injection is a concept that started more on the server side.** Dependency injection states that instead of creating an instance of the dependent service when we need it, the class or function should ask for it instead and the "injector" will be responsible for figuring out how to create it.

```javascript
// Without Dependency Injection
function fetchDashboardData() {
  var $http = new HttpService();
  return $http.get('my/url');
}

// With Dependency Injection
function fetchDashboardData($http) {
  return $http.get('my/url');
}
```

The two probable ways to write service and why the latter is better? In the first example, we use "new" keyword, we have new instance everytime we use service while **service in angular is singletons for the scope of our application, ** and two controllers ask for service A will get the vary same instance!

To use built-in services, we should remember that the built-in services are prefixed with "`$`" sign like "`$log`", "`$http`" and so on.

```javascript
myModule.controller("MainCtrl", ["$log", function($log) {}]);

myModule.controller("MainCtrl", function($log) {});
```

And here are the two ways we usually inject services, but why we prefer the former one, the one with safe style of dependency injection. 

Because of the "uglify" procedure. During the uglifing process, the variable will be shortened to some random string, while at that time, we won't be able to tell which service it is using! Also, since the "uglify" won't change string constant, it will help to identify which service we are using. 

Why we call "injection"? because the way we use those services like `myModule.controller("MainCtrl", ["$log", "$window", function($l, $w) {}]);` is similar to injecting those services for the function to use. 

### Some common services

#### $location

The `$location` service in AngularJS allows us to interact with the URL in the browser bar, and get and manipulate its value. Any changes made to the `$location` service get reflected in the browser, and any changes in the browser are im‐ mediately captured in the `$location` service. The `$location` service has the fol‐ lowing functions, which allow us to work with the URL:
- absUrl. A getter that gives us the absolute URL in the browser (called `$location`. absUrl()).
- url. A getter and setter that gets or sets the URL. If we give it an argument, it will set the URL; otherwise, it will return the URL as a string.
- path. Again, a getter and setter that sets the path of the URL. Automatically adds the forward slash at the beginning. So `$location.path()` would give us the current path of the application, and `$location.path("/new")` would set the path to /new.
- search. Sets or gets the search or query string of the current URL. Calling `$location.search()` without any arguments returns the search parameter as an ob‐ ject. Calling `$location.search("test")` removes the search parameter from the URL, and calling `$location.search("test", "abc");` sets the search parameter test to abc.

#### $http

We will deal with `$http` extensively in Chapter 6, but it is the core AngularJS service used to make XHR requests to the server from the application. Using the `$http` service, we can make GET and POST requests, set the headers and caching, and deal with server responses and failures.

```javascript
angular.module('notesApp', [])
  .controller('MainCtrl', [function() {
    var self = this;
    self.tab = 'first';
    self.open = function(tab) {
      self.tab = tab;
    };
    }])
  .controller('SubCtrl', ['ItemService', function(ItemService) {
    var self = this; self.list = function() {
    return ItemService.list(); 
    };
    
    self.add = function() {
      ItemService.add({
        id: self.list().length + 1,
        label: 'Item ' + self.list().length
      });
    };
    }])
  
  // we created ItemService using angular's module function: factory. 
  .factory('ItemService', [function() { 
    var items = [
      {id: 1, label: 'Item 0'},
      {id: 2, label: 'Item 1'}
    ];
    return {
      list: function() {
        return items; 
      },
      add: function(item) {
        items.push(item);
      } 
    };
  }]
);  
```

The point in the above example is that if we add one more item in one of the tabs, we can also see that item in the other tab, because the itemService instance in both tabs are the same. To summerize:

AngularJS guarantees the following:

-  The service will be lazily instantiated. The very first time a controller, service, or directive asks for the service, it will be created.
-  The service definition function will be called once, and the instance stored. Every caller of this service will get this same, singleton instance handed to them.

### Factory, provider and service

**There are several ways to defining a service: factory, provider and service.**

we use "factory" if we define the service in a more functional way, like in the previous example, we return an object that contains functions; or we can use "service" if we define the service in a classic class\OO way, which doesn't return anything. 

An example of using "serive" is followed:

```javascript
function ItemService() {
  var items = [
        {id: 1, label: 'Item 0'},
        {id: 2, label: 'Item 1'}
      ];
  this.list = function() {
    return items;
  };

  this.add = function(item) {
        items.push(item);
  };
}

angular.module('notesApp', [])
  .service('ItemService', [ItemService])
  .controller('MainCtrl', [function() {
    var self = this;
    self.tab = 'first'; self.open = function(tab) {
          self.tab = tab;
    };
  }])
  .controller('SubCtrl', ['ItemService', function(ItemService) {
    var self = this; self.list = function() {
      return ItemService.list(); 
    };
    self.add = function() {
      ItemService.add({
            id: self.list().length + 1,
            label: 'Item ' + self.list().length
      });
    };
  }]
);
```

### Communication with server

`$http` is a core AngularJS service that allows us to communicate with server endpoints using XHR. Like XHR such tedious task, we usually instantiate a XMLHttpRequest Object and read the response, check the error codes and so on, or using jquery's `$.ajax` syntax. 

Also, it follows the Promise interface.

```javascript
angular.module('resourceApp', ['ngResource'])
    .factory('ProjectService', ['$resource', function($resource) {
      return $resource('/api/project/:id'); 
    }]);
```

**use `ngResource` to handle RESTful API ** as it will make it extremely easy to send the "GET"\"POST" request to the server. In the above example, we produce a service called "ProjectService", which depends on the built-in module called "`$resource`", which wraps the RESTful endpoint to make our life easier as we can then use:
- ProjectService.query() to get a list of projects.
- ProjectService.save({id: 15}, projectObj) to update a project with ID 15.
- ProjectService.get({id: 19}) to get an individual project with ID 19.

The following is a full-fledged example, showing how to use `ngResource` in front end to cooperate with the back end.

<div style='text-align:center' markdown='1'>
  <iframe src="http://angular-example-dev.us-east-1.elasticbeanstalk.com/http-post-example.html" width="100%" height="500">
    <p>Your browser does not support iframes.</p>
  </iframe>
</div>

The source code is listed as followed:

```javascript
// server.js (Express 4.0)
var express        = require('express');
var morgan         = require('morgan');
var bodyParser     = require('body-parser');
var methodOverride = require('method-override');
var app            = express();

app.use(express.static(__dirname + '/public')); // this line is important as we will serve those html file directly in screen as option, in those html front-end example, we will use angular's ngResource to create http request for the backend of this server.js (the endpoint we just created using express's router).
app.use(morgan('dev')); 					// log every request to the console
app.use(bodyParser()); 						// pull information from html in POST
app.use(methodOverride()); 					// simulate DELETE and PUT


var router = express.Router();

var notes = [
  {id: 1, label: 'First Note', author: 'Shyam'},
  {id: 2, label: 'Second Note', author: 'Brad'},
  {id: 3, label: 'Middle Note', author: 'Someone'},
  {id: 4, label: 'Last Note', author: 'Shyam'},
  {id: 5, label: 'Really the last Note', author: 'Shyam'}

];
var lastId = 6;

router.get('/note', function(req, res) {
  res.send(notes);
});
router.post('/note', function(req, res) {
  var note = req.body;
  note.id = lastId; // An smart way to keep track of the last id.
  lastId++;
  notes.push(note);
  res.send(note);
});


router.post('/note/:id/done', function(req, res) {
  var noteId = req.params.id;
  var note = null;
  for (var i = 0; i < notes.length; i++) {
    if (notes[i].id == req.params.id) {
      note = notes[i];
      break;
    }
  }
  note.label = 'Done - ' + note.label;
  res.send(notes);
});

router.get('/note/:id', function(req, res) {
  for (var i = 0; i < notes.length; i++) {
    if (notes[i].id == req.params.id) {
      res.send(notes[i]);
      break;
    }
  }
  res.send({msg: 'Note not found'}, 404);
});

router.post('/note/:id', function(req, res) {
  for (var i = 0; i < notes.length; i++) {
    if (notes[i].id == req.params.id) {
      notes[i] = req.body;
      notes[i].id = req.params.id;
      res.send(notes[i]);
      break;
    }
  }
  res.send({msg: 'Note not found'}, 404);
});

router.post('/login', function(req, res) {
  console.log('API LOGIN FOR ', req.body);
  res.send({msg: 'Login successful for ' + req.body.username});
});


app.use('/api', router);



app.listen(8000);
console.log('Open http://localhost:8000 to access the files now'); // shoutout to the user

```

And the front-end part code is:

```html
<!-- File: chapter6/public/http-post-example.html -->
<html ng-app="notesApp">

<head>
  <title>HTTP Post Example</title>
  <style>
    .item {
      padding: 10px;
    }
  </style>
</head>

<body ng-controller="MainCtrl as mainCtrl">
  <h1>Hello Servers!</h1>
  <div ng-repeat="todo in mainCtrl.items"
       class="item">
    <div><span ng-bind="todo.label"></span></div>
    <div>- by <span ng-bind="todo.author"></span></div>
    <div><span ng-bind="todo.messege"></span></div>
  </div>

  <div>
    <form name="addForm"
          ng-submit="mainCtrl.add()">
      <input type="text"
             placeholder="Label"
             ng-model="mainCtrl.newTodo.label"
             required>
      <input type="text"
             placeholder="Author"
             ng-model="mainCtrl.newTodo.author"
             required>
      <input type="text" placeholder="messege" ng-model="mainCtrl.newTodo.messege" required>
      <input type="submit"
             value="Add"
             ng-disabled="addForm.$invalid">
    </form>
  </div>

<script
  src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.11/angular.js">
</script>
<script>
  angular.module('notesApp', [])
    .controller('MainCtrl', ['$http', function($http) {
      var self = this;
      self.items = [];
      self.newTodo = {};
      var fetchTodos = function() {
        return $http.get('/api/note').then(
            function(response) {
              self.items = response.data; // set the items to be the return data.
            }, function(errResponse) {
              console.error('Error while fetching notes');
            });
      };

      fetchTodos();

      self.add = function() {
        $http.post('/api/note', self.newTodo)
            .then(fetchTodos) // update items.
            .then(function(response) {
              self.newTodo = {}; // clear the form.
            });
      };

    }]);
</script>
</body>
</html>
```

### $http in detail

Promise-style syntax.

```javascript
angular.module('notesApp', [])
  .controller('MainCtrl', ['$http', function($http) {
    var self = this;
    self.items = [];
    $http.get('/api/note').then(function(response) {
      self.items = response.data;
      }, function(errResponse) {
          console.error('Error while fetching notes');
        });
  }]
);
```

why Promise is better? try thinking about a case when we have to make 3 http request in a row, when the latter ones will depend on the information from the first ones. If using callbacks, we will need to nest them all together!

```javascript
$http.get('/api/server-config')
  .then(function(configResponse) {
    return $http.get('/api/' + configResponse.data.USER_END_POINT);
  })
  .then(function(userResponse) {
    return $http.get('/api/' + userResponse.data.id + '/items');
  })
  .then(function(itemResponse) { 
    // Display items here
  }, function(error) {
    // Common error handling
});
```



## Additional information

### difference between Promise and callback in js?

As for their effect, they are pretty like the same in terms of being asynchronous while Promise's syntax looks far more clear than nested callbacks.

Promises provide a more succinct and clear way of representing sequential asynchronous operations in javascript. They are effectively a different syntax for achieving the same effect as callbacks. The advantage is increased readability. Something like this

```javascript
aAsync()
  .then(bAsync)
  .then(cAsync)
  .done(finish);
// Promise is much more readable then the equivalent of passing each of those individual functions as callbacks, like:

Async(function(){
    return bAsync(function(){
        return cAsync(function(){
            finish()
        })
    })
});
```

简单来说， Promise就是syntactic sugar。Everything that can be written in Promise can be written in nested callbacks.

### difference between websocket and RESTful API?

It really depends on the context, whether it requires less interaction like reading a blog, or requires time browsing; or it requires rich interaction and messege sending. For the former, close the connection during reading or browsing may actually save resources, which is exactly what HTTP does, while the latter one calls for websocket!!

**HTTP is a pull service, while websocket is bidirectional.**

参考[这篇博客](https://www.pubnub.com/blog/2015-01-05-websockets-vs-rest-api-understanding-the-difference/)介绍得非常详细!!
