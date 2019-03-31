title: Twitter engine in React
date: 2016-01-06 23:10:20
tags: [javascript]
categories: 技术
---

The hand-on project to get myself familiar with React.js, which pulls the latest post from Twitter by using a nodejs module in client-side javascript and allows users to form their own collections and share them via Codepen or other platforms. 

<!-- more -->

![screen capture](http://ww4.sinaimg.cn/large/c5ee78b5gw1ezqtafuny9j21kw0uhqhx.jpg)

**Some important details you want to learn on this project**

## Browserify

used for building all the dependency file together in such a way that we can use Node.js module to build up out client-side application. We install it in this way:
```
npm install - - save-dev browserify 
```
Notice, here is a save-dev flag, which tells npm that it is a development dependency, it will write this dependency in package.json file. Writing a module name into package.json tells npm to install when executed command: `npm install`. Here is a distinction between running dependency and developing dependency. And since Browserify is used during build time, so it belongs to developing dependency. 

## Writing style

```
var React = require('react');
var Stream = require('./Stream.react.js');
var Collection = require('./Collection.react.js');

var Application = React.createClass({
	getInitialState: function(){
		return {
			collectionTweets: {}
		};
	},

	addTweetToCollection: function(tweet){
		var collection = this.state.collectionTweets;
		collection[tweet.id] = tweet;
		this.setState({
			collectionTweets: collection
		});
	},
	removeTweetFromCollection: function(tweet){
		var collection = this.state.collectionTweets;
		delete collection[tweet.id];
		this.setState({
			collectionTweets: collection
		});
	},

	removeAllTweetsFromCollection: function(){
		this.setState({
			collectionTweets: {}
		})
	},

	render: function(){
		return (
				<div className="container-fluid">
					<div className="row">
						<div className="col-md-4 text-center">
							<Stream onAddTweetToCollection={this.addTweetToCollection} />
						</div>
						<div className="col-md-8">
							<Collection tweets={this.state.collectionTweets} onRemoveTweetFromCollection={this.removeTweetFromCollection}
							 onRemoveAllTweetsFromCollection={this.removeAllTweetsFromCollection} />
						</div>
					</div>
				</div>
			)
	}
});
module.exports = Application;
```


It is in out Application.react.js. The reason we adopt a CommonJS writing style is that it will be convenient for other part of the file to require this react component we just build. So we use  such `module.exports = Application;` to allow other file when used to require this component. 

## Children elements change parent’s elements

Focus on this part:

```
<Stream onAddTweetToCollection={this.addTweetToCollection} />
```
the function defined in this react component is passed in, which indicates that this function will be called inside Stream component where since we know addTweetToCollection embodies a `setState` method, it illustrates how child element can update its parent component’s state.

Thus, in Stream component, we can access this method by using `this.props.onAddTweetToCollection`. ** Child component feed the arguments to parent’s state-changing function which will trigger `render()` function to re-render the whole children component again. **

## React lifecycle method API like componentDidMount()
This function is part of react API, that will be called once after the initial rendering finished. At that time, we have a initialed DOM tree, and it will be a perfect time for using another js library! 

```
	componentDidMount: function(){
		SnapkiteStreamClient.initializeStream(this.handleNewTweet);
	},

	compoentWillUnmount: function(){
		SnapkiteStreamClient.destroyStream();
	},
```

`componentWillUnmount()` will be called when react unmount the components.

And in general, react lifecycle methods can be grouped into three phases.
mounting, updating and unmounting. 

And in this coding example, we see `componentDidMount` and `componentWillUnmount`. Also, we have `componentWillMount` and other methods

> Note that `componentDidMount` will be the method when DOM is ready. Thus we usually will introduce other JS library at this method to do something on the DOM tree. For example, Jquery, setInterval, setTimeout and so on.

say in this example, if we want to use setInterval method:

```
        componentDidMount: function() {
          this.interval = setInterval(this.handleTick, 1000);
        },
        componentWillUnmount: function() {
          clearInterval(this.interval);
        },
```

And we use react-don node.js module here. 

Some of other lifecycle methods are: `shouldComponentUpdate`, this will determine whether or not to call the render function, and `forceUpdate` can skip this function checking. Note that it is a good way to enhance app’s speed when in hundreds of components app. `componentWillRecieveProps` will invoke wen receiving new props can use `setState` inside this method while the similar method `compontWillUpdate` cannot. `componentDidUpdate` will invoke after each update. 

## getDefaultProps
it will set the props if it receive no props from parent components

## Checking for props exist?
the predicate statement at parent component may sometimes determine whether or not to render a children component. If not, then in later children component part, it should check whether it receives props from parent component. 

## Validation function for properties
`propTypes` is used for validating if a property is used and has value. If not, it will report an error to console.

```
	propTypes: {
		tweet: function(properties, propertyName, componentName){
			var tweet = properties[propertyName];

			if(!tweet){
				return new Error('Tweet must be set. ');
			}

			if(!tweet.media){
				return new Error('Tweet must have an image');
			}
		},

		onImageClick: React.propTypes.func
	},
```

So in `propTypes`, we are validating the existence of Tweet by obtaining the tweet property object from `properties[propertyName]`. And for validating the `onImageClick` part, we only need to ensure that it is a function. so we did:

```
onImageClick: React.propTypes.func
```	

Some similar validation functions provided by React are: React.propTypes.number and so on.

## this.refs

Keep in mind, however, that the JSX doesn't return a component instance! It's just a ReactElement: a lightweight representation that tells React what the mounted component should look like. In other word, we can insert `ref` property in `render()` , the component it renders, so that we can access that component outside `render` function.

```
componentDidMount: function(){
	this.refs.collectionName.focus();
},

render: function(){
	return (
			<form className="form-inline" onSubmit={this.handleFormSubmit}>
				<Header text="Collection Name: " />

				<div className="form-group" style={inputStyle} onChange={this.handleInputValueChange}
				 value={this.state.inputValue} ref="collectionName" />
				 </div>

				 <Button label="Change" handleClick={this.handleFormSubmit} />
				 <Button label="Cancel" handleClick={this.handleFormCancel} />
			</form>
		)
}
```

we know that `componentDidMount` will be called instantly after DOM tree is ready.  


## Bootstrap usage in this project 


```
<div className="container-fluid">
					<div className="row">
						<div className="col-md-4 text-center">
							<Stream onAddTweetToCollection={this.addTweetToCollection} />
						</div>
						<div className="col-md-8">
							<Collection tweets={this.state.collectionTweets} onRemoveTweetFromCollection={this.removeTweetFromCollection}
							 onRemoveAllTweetsFromCollection={this.removeAllTweetsFromCollection} />
						</div>
					</div>
				</div>
```

It is where we use some Bootstrap property to quickly add style to the components. Note that we only add those style at the wrapper element for example we always wrap a `div` outside the target element. 

references [this post](http://getbootstrap.com/css/) for more Bootstrap property.

- `container-fluid` for a full width container, spanning the entire width of viewport.
- `text-center` to put the innerHTML text at the center of the element. 
- `row` will create a horizontal groups of elements. 
- `col-md-8` and `col-md-4` for sparing width horizontally.
- `form-group` for optimum spacing for labels and input controls.
- `form-control` for element inside the form wrapper, usually appear with the `form-group` class. 

## Try to add color palette using Mustache.js and ColorThief.js

> Due to my technical issue, I can only make it a local version. I will try me best to host it online.















