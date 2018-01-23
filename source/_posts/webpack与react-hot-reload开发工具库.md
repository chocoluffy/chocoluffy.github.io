title: webpack与react\redux前端开发工具库
date: 2016-07-18 23:28:05
tags: [react, redux]
categories: 技术
---

对Dan Abramov开源的react hot loader boilplate的浅探， 同时复习一下webpack与react搭配开发时的常用配置。[Github Source](https://github.com/chocoluffy/react-hot-boilerplate)

<!-- more -->
## Babel

通常用到的plugin, 在package.json里面保存的module有： "babel-loader"\"babel-preset-es2015"\"babel-preset-react"， 使用babel-loader, 一是可以在`.babelrc`这个文件里面写出使用另外两个module的配置， 或者， 在webpack里面的loaders部分添加相应的code来实现同样的功能。其中"babel-preset-es2015"是将es6的js语法compile成es5的， 现在IE9以上及大部分的主流浏览器目前都支持ES5语法了。

> 至于ES6和ES5有什么区别， 以及即将到来的ES7有什么意义， 集成了大部分的functional programming的特性， 本来可能需要引用underscore.js的函数现在可能直接就可以用了。包括spread operator, function binding(::), arrow functions, modules export， 这些都是非常便捷和广泛采用的语法呢~

而“babel-preset-react”则是将JSX译成JS的插件。

```js
// webpack.config.js
module.exports = {
  devtool: 'inline-source-map',
  entry: ['./client/client.js'], // 将entry下的client.js最终打包成dist/bundle.js。
  output: {
    path: './dist',
    filename: 'bundle.js',
    publicPath: '/'
  },
  module: {
    loaders: [
      {
        test: /\.js$/, // 利用正则表达式来匹配所有以.js结尾的文件， 同时排除node_modules里面的js文件。
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          presets: ['react', 'es2015']
        }
      }
    ]
  }
}
```

注意在express里面， 我们通常会调整前端index.html引用资源的路径为“./dist”:

```js
app.use(express.static('./dist'));
```

这样的在index.html里面引用bundle.js就可以直接：`<script src="bundle.js"></script>`就好了。

然后在webpack.config.js写好之后， `webpack --config webpack.config.js`可以run webpack。然后`nodemon server.js`就可以开始运行了。当然webpack也有hot reloading的功能。不用每一次都rebuild一次webpack， 而是可以在react里面看到更新component的变化。

## React Hot Reloading

具体的做法是将webpack当成一个middleman来hook服务器。相比nodemon， webpack的好处就是， 它并没有restart server, nodemon是会watching整个"*"， 而webpack只是更新改变的部分。所以我们希望的是让webpack来管理关于react component的部分， 而nodemon只是来监听剩下的部分， 例：`nodemon server.js --ignore components`， 这样nodemon会忽略所有components文件夹下面的改动。

要使用hot module reload，下载一个babel的插件， 其实babel主要的功能还是在compile上， webpack的主要作用还是在project building这个过程， 然后中间有很多相关的插件是相互联系的， 比如我们现在准备使用的这个“babel-preset-react-hmre”。

```js
// updated webpack.config.js

var webpack = require('webpack');

module.exports = {
  devtool: 'inline-source-map',
  entry: [
    'webpack-hot-middleware/client',
    './client/client.js'
    ], // source file
  output: {
    path: require("path").resolve("./dist"),
    path: './dist',
    filename: 'bundle.js',
    publicPath: '/'
  },
  plugins: [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorPlugin()
  ],
  module: {
    loaders: [
      {
        test: /\.js$/, // search all files with ".js" as last.
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          presets: ['react', 'es2015', 'react-hmre']
        }
      }
    ]
  }
}
```

之前写的基本都是babel的插件， 现在引入了`npm install --save webpack`的插件， 同时为了避免多次执行`webpack --config webpack.config.js`，我们把webpack.config.js引入express server. 

```js
// server.js
var express = require('express');
var path = require('path');
var config = require('../webpack.config.js');
var webpack = require('webpack');
var webpackDevMiddleware = require('webpack-dev-middleware');
var webpackHotMiddleware = require('webpack-hot-middleware');

var app = express();

var compiler = webpack(config);

app.use(webpackDevMiddleware(compiler, {noInfo: true, publicPath: config.output.publicPath}));
app.use(webpackHotMiddleware(compiler));

app.use(express.static('./dist'));

app.use('/', function (req, res) {
    res.sendFile(path.resolve('client/index.html'));
});

var port = 3000;

app.listen(port, function(error) {
  if (error) throw error;
  console.log("Express server listening on port", port);
});
```

## React Hot Boilerplate

最后的成果见这里， [minimum react hot boilerplate](https://github.com/chocoluffy/react-hot-boilerplate/blob/master/webpack.config.js)， fork自redux的作者dan abramov。他写的react hot loader boilerplate是我看过的最好的使用starter kit!

最后还想提出的一点， 主要关于ES6里面关于函数的this binding的问题， 通常来说，ES6的arrow可以解决这个问题，或者说在每次render里面调用函数的时候加上`.bind(this)`。 但是最好的办法还是写在constructor里面， 这样的函数只会bind一次之后都可以一直用。下面附上官方的使用范例：

```js
export class Counter extends React.Component {
  constructor(props) {
    super(props);
    this.state = {count: props.initialCount};
    this.tick = this.tick.bind(this);
  }
  tick() {
    this.setState({count: this.state.count + 1});
  }
  render() {
    return (
      <div onClick={this.tick}> // don't need to use arrow type or bind function here anymore since bind in contructor.
        Clicks: {this.state.count}
      </div>
    );
  }
}
Counter.propTypes = { initialCount: React.PropTypes.number };
Counter.defaultProps = { initialCount: 0 };
```
不得不说， 这个starter kit和chrome的react dev tool搭配用起来， 写react的项目真的是一种享受。

## Trouble Shooting

在写react\redux的时候， 由于现在需要使用babel来compile一遍写的code， 很多bugs都是在于对babel的不熟悉而来而导致的编译不成功， 而这些时候， 由于没有办法像以前一样在chrome inspect来debug， 必须对一些基础的使用有一定了解才可以绕过去。特别是在引入webpack之后， 配置在前期挺麻烦的， 但是一旦把开发环境搭建好了， 后期的开发就特别轻松和享受了~也在这个部分， 把我遇到的， 和觉得有价值的细节都提出来， 和大家分享~

### Why my jsx element not showing correctly?
[config sublime text to highlight jsx](http://gunnariauvinen.com/getting-es6-syntax-highlighting-in-sublime-text/)

### Anything about ES6 syntax error by browser.
For example, `store.js:1 Uncaught SyntaxError: Unexpected token import`, check[this post](http://stackoverflow.com/questions/33460420/babel-loader-jsx-syntaxerror-unexpected-token) for more information about babel plugins, however, we also need to pay attention to the path that plugins take effect. For example, in the "webpack.config.js" file, the module part looks like this:
```javascript
module: {
	loaders: [{
	  test: /\.js$/,
	  loaders: ['react-hot', 'babel'],
	  include: path.join(__dirname, 'src')
	}]
}
```
It means that "react-hot" && "babel" will collect files from "/src" folder and apply two loaders on it. Thus, any folder outside the path the "/src" will be ignored by loaders. In our original example, store.js is located outside "/src", thus the `import` syntax will not be converted into es2015 that browser can recognize, thus gives such error. 

### Pressing "enter" don't automatically submit the input

It's more like a UX experience than a problem. In the traditional input and button structure:
```javascript
<input 
	placeholder="typing something here..."
	value={this.state.inputText}
	onChange={this._onChange}
/>
<button onClick={this._onClick}>Submit</button>
```
However, after user types in something in the input box, pressing "enter" key won't directly submit the input. Thus, we want to improve it by converting it into a form style to automate whole process:
```javascript
<form onSubmit={this._onClick}>
	<input 
		placeholder="typing something here..."
		value={this.state.inputText}
		onChange={this._onChange}
	/>
	<input type="submit" text="Submit"/>
</form>
```
Then, pressing "enter" key right after you finish typing should work!

## Tricks and Notes

### Render JSX with if-else logic control

Sometimes, we just want to render JSX depending on some state values like in Angular. We can simple assign JSX to variable inside `render()`, and note that we need a parathesis around JSX for assignment. This code snippet is used in [redux-todolist](https://github.com/chocoluffy/redux-todolist). Do note that to avoid confusion, I still use `.bind(this)` syntax below, but I recommend to put binding logic inside `constructor()`. 
```javascript
render(){
	var todoText;
	if(this.props.todo.isCompleted){
		todoText = (
			<div><s>{this.props.todo.text}</s></div>
		)
	}
	else{
		todoText = (
			<div>{this.props.todo.text}</div>
		)
	}
	return (
		<li>
			{todoText}
			<button onClick={this._onComplete.bind(this)} >Complete</button>
		</li>
	)
}
```
Some other times, in order to keep render function clean, we will move the render logic into another function to return JSX syntax and call that function inside `render()`, note that we don't need the `.bind(this)` syntax in this case! Because, the whole reason of using `.bind(this)` is that inside the _onClick handler function, the `this` will points to nothing(null), instead of the React component, which may causes the "this.props" not found error and the like. However, in this case, we simply return JSX syntax based on if-else logic, and we won't need the binding.
```javascript
renderTodoText(){
	if(this.props.todo.isCompleted){
		 return (
			<div><s>{this.props.todo.text}</s></div>
		)
	}
	else{
		return (
			<div>{this.props.todo.text}</div>
		)
	}
}

render(){
	return (
		<li>
			{this.renderTodoText()}
			<button onClick={this._onComplete} >Complete</button>
			<button onClick={this._onDelete}>Delete</button>
		</li>
	)
}
```
Check more information in [this post](http://devnacho.com/2016/02/15/different-ways-to-add-if-else-statements-in-JSX/).

### Webpack in production

Pretty similar with using webpack in dev mode, but much simpler in that you only need to specify a correct output path, and webpack will handle the else stuff. And it contains Uglify plugins and others that can help produce the production bundle.js file.

check [this post](http://www.pro-react.com/materials/appendixA/) for more information.

### How redux's state update react's components

When you use Redux in React application, follow one simple rule - all your components are stateless (means, **no component initializes its state or calls .setState() anywhere**).

The redux way of design based on state container, one big object that holds all application state. As React component, being connected to Redux store, Redux will pass the state (or portion of it) into that component, as this.props.state property.

That high-order component (or smart component), renders its children components (or dumb components) and handles events from them.

If child component requires change, it triggers corresponding handler (which typically passed as props). The only way to change the state is to dispatch an action. That action contains a type and a payload and based on that type, corresponding reducer is selected. The reducer then produces a new state, based on previous state and action payload.

**If in the result of reducer call, state got changed, Redux will re-render high-order component, passing new state in properties. So, all child components will be updated correspondingly.**

Check [this post](http://stackoverflow.com/questions/33668827/refresh-logic-in-react-component-or-flux-redux) for more information.

### How to use seperate reducers to handle different parts of state

One thing to note that in seperate single reducers functions like this one, we no longer pass in the whole state tree, but instead the correct portion of that state tree, in this case, only todos array. And this part of code handles that:

```javascript
import { combineReducers } from 'redux';
import todoReducer from './todoReducer';
import userReducer from './userReducer';

const rootReducer = combineReducers({
    todos: todoReducer,
    user: userReducer
})

export default rootReducer
```
Note that after we split the reducer function, we will also update all related files.

