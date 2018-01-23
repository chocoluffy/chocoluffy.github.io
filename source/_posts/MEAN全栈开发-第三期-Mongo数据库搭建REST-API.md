title: 'MEAN全栈开发[第三期-Mongo数据库搭建REST API]'
date: 2016-03-22 22:50:55
tags: [web design, javascript, nodejs]
categories: 技术
---

AirLoft的原型。 第三期， 基于mongodb的mongoose来搭建RESTful API， 主要包括了关于各类涉及到对象的GET, POST, PUT DELETE方法的实现。 在postman上不断的模拟， 也最终搭好一个稳定且flexible的后端API处理， 剩下的就是将数据库和这个Express App的controller结合， 并在前端上灵活的应用啦！如果说前端就像一个人的妆容， 那么数据库以及API处理就是他的谈吐和内涵， 这个应用也有了scaling的能力， 加油!

<!-- more -->

![screenshot](http://ww1.sinaimg.cn/large/c5ee78b5jw1f26lk141v7j21kw0tjn61.jpg)

## 前言

In MVC architecture, we need to have views without content or data. An common way to implement MVC architecture is to **first build up a frontend clickable prototype, then extract the content from the view back to controller(concerned with data structure), then back to model.** And now we are in the second step, we try to put variable in jade file in place of content, and put the content as variable into the controller.


## Mongoose

First set up a connection URI like: `var dbURI = 'mongodb://localhost/airloft';`, username, password and port number is optional for localhost.


A stupid mistake!! Need to open the `mongod` before you tried to connect to it. One thing to notice is that Mongoose connection doesn't automatically close when the application restarts or stops. In order to do that whenever we restart the `nodemon`, we will need to listen for nodejs event. Nodemon uses `SIGUSR2`, application termination uses `SIGINT`, Heroku uses `SIGTERM`, like:

```js
var graceShutDown = function(msg, callback){
	mongoose.connection.close(function(){
		console.log('Mongoose is closed through ' + msg);
		callback();
	});
};

process.once('SIGUSR2', function(){
	graceShutDown('nodemon restart', function(){
		process.kill(process.pid, 'SIGUSR2');
	});
});
```

use `process.once` to overwrite the default `SIGUSR2` function, but then use `kill` to resend the `SIGUSR2` signal again, but this time we hook up a msg display functionality. Especially the place, we use `process.once()` instead of `process.on()` in the `SIGUSR2` case, since nodejs will listen for the same event, and if we use `on`, then it will forms a infinite loop. Note that `process.kill()` serves the functionality of sending the signal.

> Recap: Basically four step as discussed here, first define a connection URI string, then second setup the db connection; third monitor the mongoose connection events like `connected` and `disconnected`, and fourth monitor the node process event in order to close the db connection when we restart.

From view to controller, finally to store in db is what we have gone through so far. It works pretty well, since the moment we move the data to the controller, we gradually solidy the data structure we want to use!!

Some technical names: "path" is like attribute names in relational database while "property object" is like the values but like other JS object, can be nested. Also, we can add data validation inside the schema, two advantages: 
  - save the roundtrip time to datebase
  - save the code inside the application for validation.

Adding indexes can make database search more efficiently, jist like adding index to the files you want to search in your drawer. In order to add a GeoJSON path into your application, you only need to do this: `coords: {type: [Number], index: '2dsphere'}`; using `2dsphere` allows mongodb to be able to calculate the geolocation fast, thus **it is helpful to build a location-based application.**

Subdocument is helpful when handling nested data structure, one thing to note, when creating attributes like `timestamp`, we use data type called `Date`, like:   

```js
var reviewSchema = new mongoose.Schema({
	rating: {type: Number, "default": 0, min: 0, max: 5},
	author: String,
	createdOn: {type: Date, "default": Date.now},
	text: String;
});
```

![mongo](http://ww3.sinaimg.cn/large/c5ee78b5gw1f1wrkszhcej218w0u6wib.jpg) 这张图讲得很清楚， schema是application-side的东西， 每一个model是的实例instance通过schema可以map到database里面的每一个document, 1:1的对应关系。

While typing in `mongod` will let you start the mongodatabase, using `mongo` will start tht shell and let you connect to the test database. And some useful commands in mongo go here:
  - `show dbs` to show all existing database so far.
  - `use local` to switch to another database. And if that db doesn't exist yet, mongo will create it for us.
  - `show collections`
  - `db.startup_log.find()` returns all the content from collection, uesful when we check whether the data has been saved.
  - `db.missions.save({...})` will savev a new document into collection.
  - `db.inventory.remove({})` will remove all documents in collection `inventory`.
  - `db.missions.update()` will query a document and update its content. The first argument is query string, and second argument use `$push` to insert subdocuments.

```js
 > db.locations.update({ 
   name: 'Starcups'
  }, { 
    $push: {
      reviews: {
        author: 'Simon Holmes',
        id: ObjectId(),
        rating: 5,
        timestamp: new Date("Jul 16, 2013"),
        reviewText: "What a great place. I can't say enough good things about it."
      } 
      
    }
})
```

So far, we have insert a fake data document in our local computer, but in real life, **we want database to be externally accessible.** use `heroku addons:add mongolab` to register a db URI at mongolab as a heroku addons.** And use `heroku addons:open mongolab` to go the website interface to check database details. **In order to get the uri of the database, type `heroku config:get MONGOLAB_URI`. 

> Note that in real practice, I have to fixed a typo bug from my previous data stored in mongolab, I have to first go to the mongo shell to `remove({})` and `insert({...})` again, then do the `mongodump` and `mongorestore` again to dump the data into the temp folder at `~/tmp` and push the data to live database. And make sure to press the "Delete all collection" button before we did `mongorestore` to avoid same key collision.

After receive URI, we will first dump our localhost data into a folder in local computer, then restore the data to the live database. use `mkdir -p ~/tmp/mongodump` will create a folder to hold up the dumped data. Note that use `-p` option will create the non-existed folders on the path like "tmp".
  - use `mongodump -h localhost:27017 -d airloft -o ~/tmp/mongodump` to export airloft.missions data into BSON.
  - use `mongorestore -h <host and port number> -d <live database name> -u <username(same as database name)> -p <password> <path to dump data folder>` to push the data up to the mongolab live database.
  - Last step(testing), we can use `mongo hostname:port/database_name -u username -p password` to change the `mongo` to interact with an external database. Note that in the last two steps, database name is the same as username. Then, we can use commands introduced before to interact with live database. In summery, we have one source code and can be used to manipulate databases at two locations, one in local computer, a test database, and one in Heroku, a live database.

Let application use right database. use `heroku config:set NODE_ENV=production` to set the environment variable `NODE_ENV` to be production for Heroku. **Environment variable will affect the way the core process runs.** When we tried to use `nodemon` to start application, one way to make sure what environemnt we are running in is to prepend a ENV variable before nodemon like `NODE_ENV=production nodemon`, and corresponds to this change, we also change the code in db.js(with a if-else block) to set the dbURI aligned with environment. In application, we can access to such variable by `process.env.NODE_ENV`, but since we post it in public repo, we don't want our credentials to be public. Instead, we use environment variables from Heroku configuration.

```js
var dbURI = 'mongodb://localhost/airloft';

if(process.env.NODE_ENV === 'production'){
	dbURI = process.env.MONGOLAB_URI;
}

mongoose.connect(dbURI);
```

## REST APIs

REST is an architecture style, it's stateless, meaning it will not recognize users or history. Having such program interface will allow us to talk to our database through HTTP and perform CRUD operations then send back a HTTP response. An way to construct URLs is to think about the collections in our database. In 'airloft.missions' collection, we may want to allow operations like:
  - `/missions` to create an new mission.
  - `/missions` to read all missions.
  - `/missions/<index>` to read a specific mission.
  - `/missions/<index>` to update a specific mission. And so on so forth.

As we can see the urls are same for several operations, and we will use different request methods to tell the server what action to take.
  - `POST` to create new data in database(from submitting form).
  - `GET` to read data.
  - `PUT` to update a document.
  - `DELETE` to delete a document.

```js
// missions
router.get('/missions', ctrlMissions.missionsListByDistance);
router.post('/missions', ctrlMissions.missionsCreate);
router.get('/missions/:missionid', ctrlMissions.missionsReadOne);
router.put('/missions/:missionid', ctrlMissions.missionsUpdateOne);
router.delete('/missions/:missionid', ctrlMissions.missionsDeleteOne);
```

Then in the corresponding controller files, we define these functions and fill them with the simplest response to display when received such request.

```js
var sendJsonRes = function(res, status, content){
	res.status(status);
	res.json(content);
}

module.exports.missionsListByDistance = function(req, res){
	sendJsonRes(res, 200, {"status": "success"});
}
```

## "GET" method implementation

Some useful queries in Mongoose:
  - `find` general search based on query object.
  - `findById` look for specific ID.
  - `findOne` get the first match document.
  - `geoNear` find geo-closef query.
  - `geoSearch` add query functionality to geoNear operation.

After using queries, we use `exec` method execute the query and passes a callback function that will run when the operation is complete. The callback function should accept two parameters, an error object and the instance of found document.

```js
var sendJsonRes = function(res, status, content){
	res.status(status);
	res.json(content);
}

module.exports.missionsReadOne = function(req, res){
	Missions
		.findById(req.params.missionid)
		.exec(function(err, mission){
			sendJsonRes(res, 200, mission);
		})
}
```

Then, we want to add error checking like this: note that we can also utilize `console.log` to print out some useful information about the data in terminal since we use `nodemon`. 

In real practice, we may not always want to retrive a whole document from mongodb, we may only just need some specific data. Thus, we can limit the data being passed around to improve speed, using `select` to retriece only "name" and "reviews" entry from a document in collection. Like this:

```js
module.exports.reviewsReadOne = function(req, res){
	if(req.params && req.params.missionid && req.params.reviewid){
		Missions
			.findById(req.params.missionid)
			.select('name reviews')
			.exec(function(err, mission){
				if(!mission){
					sendJsonRes(res, 404, {
						"message": "missionid not found"
					})
					return;
				}else if(err){
					sendJsonRes(res, 404, err);
					return;
				}
				var response, review;
				review = mission.reviews.id(req.params.reviewid);
				if(!review){
					sendJsonRes(res, 404, {
						"message": "reviewid not found!"
					})
					return;
				}
				response = {
					mission: {
						name: mission.name,
						id: req.params.missionid
					},
					reviews: review
				};
				sendJsonRes(res, 200, response);
			});
	}else{
		sendJsonRes(res, 404, {
			"message": "No missionid or reviewid in request"
		})
	}
}
```

Apart from the error checking in the above code, we can use `id` to query subdocument the `_id` entry. **note that in the raw data, I mistakenly put the entry name to be `id` instead of `_id`, which causes me to re-insert the data again to let the `id()` work for subdocument.**

These above example codes shows us how to simulate "GET" request for mission and reviews in "missions" collection in live mongolab database. When it comes to geo-query, we need to query the longtitude and latitude in `req.query` with some urls like this: `api/missions?lng=-12.34343434&lat=51.22424224`.

Besides, the way writing the js code is quite important using closure!! I use an example that will be reused in later geo-distance calculation to illustrate how to **only expost functions for later use with closure to wrap the inner variables from outer collisions.**

```js
var theEarth = (function(){
  var earthRadius = 6371;
  var getDistanceFromRads = function(rads){
    return parseFloat(earthRadius * rads);
  }
  var getRadsFromDistance = function(distance){
    return parseFloat(distance/getRadsFromDistance);
  }
  return {
    getDistanceFromRads: getDistanceFromRads,
    getRadsFromDistance: getRadsFromDistance
  }
})()
```

Then the complete geo searching functions are:

```js
// for main page listing by distance.
var resToList = function(results){
	var lst = [];
	results.forEach(function(doc){
		lst.push({
				distance: theEarth.getDistanceFromRads(doc.dis),
				name: doc.obj.name,
				author: doc.obj.author,
				rating: doc.obj.rating,
				tags: doc.obj.tag,
				_id: doc.obj._id
		})
	})
	return lst;
};

module.exports.missionsListByDistance = function(req, res){
	if(req.query.lng && req.query.lat){
		var lng = parseFloat(req.query.lng);
		var lat = parseFloat(req.query.lat);
		var point = {
			type: "Point",
			coordinates: [lng, lat]
		};
		var geoOptions = {
			spherical: true,
			maxDistance: theEarth.getRadsFromDistance(parseInt(req.query.maxdistance||2000)),
			num: 10,
		};
		// console.log(geoOptions.maxDistance);
		Missions.geoNear(point, geoOptions, function(err, results, stats){
			if(err){
				sendJsonRes(res, 404, err);
				return ;
			}
			sendJsonRes(res, 200, resToList(results));
		});
	}
	else {
		sendJsonRes(res, 404, {
			"message": "Found no longtitue or lattitude in query string."
		});
		return;
	}
}
```

> So far, we complete all three "GET" methods for this website, namely, [1]ListByDistance for the main page "/api/missions"; [2]get a single mission information for each mission document in db "/api/missions/<_id>"; [3]get a single review information for reviews from each mission document as subdocument "/api/missions/<_id>/reviews/<_id>". And next, we will look at other methods like "POST", "PUT" and "DELETE".

## "POST" method implementation

In this project, since we only involve missions and reviews, we need to implement new mission post and new review post from form data, which is stored at `req.body.<attr>`.
The way we create an document is using `create()` directly :

```js
module.exports.missionsCreate = function(req, res){
	Missions.create({
		name: req.body.name,
		rating: req.body.rating,
		tag: req.body.tags.split(","),
		author: req.body.author,
		coords: [parseFloat(req.body.lng), parseFloat(req.body.lat)],
		timepanel: {
			title: req.body.timetitle,
			timeslots: req.body.timeslots.split(",")
		}
	}, function(err, mission){
		if(err){
			sendJsonRes(res, 404, err);
		}else{
			sendJsonRes(res, 201, mission);
		}
	})
}
```

For subdocuments or facing with a list instead of an array, we probably just retrieve that list and `push` a new item into the list. Then we just need to `<instance>.save()` to save the item like this:

```js
var addReiview = function(req, res, mission){
	mission.reviews.push({
		rating: req.body.rating,
		author: req.body.author,
		text: req.body.text
	})
	mission.save(function(err, mission){
		var thisReview;
		if(err){
			sendJsonRes(res, 404, err);
		}else{
			updateAveRating(mission._id);
			thisReview = mission.reviews[mission.reviews.length - 1];
			sendJsonRes(res, 201, thisReview);
		}
	})
}
```

## "PUT" method implementation

"PUT" method is similar to "POST" in a way that they both use form data stored in `req.body`, while one is create from nothing and add to the database, the other is to find an existing one and update part of the information. 
- One hack I thought about is to use `Object.keys(obj)` to obtain the keys from a js object, then using `$set` in `mongo.update()` to only update the value in body? **Ideas:** this idea only works when all field are requiring same manipulation from body data. To be more specifically, some data are needed to be processed to feed for later use, such as we add `.split(",");` for tags data, and some fields like "coords" is an array. Thus, if we want to apply more operations on some data, we cannot just treat them in the same way in a for loop
- Or, utilize the the way mongoose model treat model parameters, we can do `var newReview = new Review(req.body)` to create an instance of "Review" model, then use this to replace the old one?

> One important thing to notice is that when we save, we save **parent document!** In our case, we did `mission.save(function(err, mission))` instead of `review.save(...)`!

## "DELETE" method implementation

"DELETE" method is easier, we only need to find that document by "missionid", then do `Missions.remove(function(err, mission))`. For the subdocument, we simply find that subdocument and call remove at the end. The prototype is like:

```js
// A working prototype without error checking.
module.exports.reviewsDeleteOne = function(req, res){
	Missions
		.findById(req.params.missionid)
		.select("reviews")
		.exec(function(err, mission){
			if(err){
				sendJsonRes(res, 404, {
					"message": "Found no match"
				})
			}
			mission.reviews.id(req.params.reviewid).remove();
			mission.save(function(err, mission){ // save parent document.
				updateAveRating(mission._id);
				sendJsonRes(res, 204, null);
			})
		})
}
```

## Summery

- How to insert an common model instance into mongodb? I mean, since we can't generate the "_id" by ourselves, then how comes we insert such object into `mongo`? **Answer:** we need to know the difference between `db.missions.save` and `db.missions.insert`, using `save`, we can simple provide an model instance according to the model schma, while using using `insert`, we have to write the object exacty the same as the final document! 

- "GET" method implementation? **Answer:** using mongodb query like `findById` and others to get the document from db, and sometimes we need `id` to retrieve info from subdocument. Besides, `geoNear` is handy in mongodb to get displaying documents by distance.

- Some important places for error checking: 
  - If argument is in the `req.body` or `req.query` or `req.params`. **if not, return a message in `res` saying founding no argument in coming request.**
  - Then given an ID(probably), we may want to search that document in database using `getById()`, and the callback function contains an `error` object and a instance object, where the returning instance object indicates whether or not searching database is succeeded or not. **If not, return a message saying object not found in database.**
  - When we tried to update of create a new document, we may usually use `save` and `create`, the callback function contains an error object either, **it indicates whether or not such instance can be created or updated correctly, if the error message appears, it usually dues to the fact that some fields violates the validation rules specified in database schema.**

## Tools

- Unless you fancy adding hundreds of script tags to your pages, you need a build tool to bundle your dependencies. You also need something to **allow NPM packages to work in browsers**. This is where Webpack comes in.
- Add a .gitattributes file and push it to github to overwrite the project type calculated by github, adding `*.css linguist-language=Javascript` into the file to let a specific file being overwritten.

















