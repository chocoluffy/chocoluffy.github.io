title: React/ES6 style guideline
date: 2016-08-01 16:41:46
tags: [react, javascript]
categories: 技术
---

用React完成了好几个小项目， 同时还在学习React Native开发， 记录一些ES6特别便捷的用法和guideline。持续更新...

<!-- more -->

## React conventions

### propType and defaultProps

使用propType不仅仅是检查props数据的格式， 也是提醒自己这个组件可以利用的来自母组件的数据， 方便以后开发。

```js
// Title.jsx
class Title extends React.Component {
  render() {
    return <h1>{ this.props.text }</h1>;
  }
};
Title.propTypes = {
  text: React.PropTypes.string
};
Title.defaultProps = {
  text: 'Hello world'
};

// App.jsx
class App extends React.Component {
  render() {
    return <Title text='Hello React' />;
  }
};
```

### this.props.children

```js
class Title extends React.Component {
  render() {
    return (
      <h1>
        { this.props.text }
        { this.props.children }
      </h1>
    );
  }
};

class App extends React.Component {
  render() {
    return (
      <Title text='Hello React'>
        <span>community</span>
      </Title>
    );
  }
};
```

### Dependency injection

One disadvantage of using react, is that when we need to pass down data to a deeply-nested component, which requires passing props all along the way.

### A simple switcher example

```js
class Switcher extends React.Component {
  constructor(props) {
    super(props);
    this.state = { flag: false };
    this._onButtonClick = e => this.setState({ flag: !this.state.flag });
  }
  render() {
    return (
      <button onClick={ this._onButtonClick }>
        { this.state.flag ? 'lights on' : 'lights off' }
      </button>
    );
  }
};

// ... and we render it
class App extends React.Component {
  render() {
    return <Switcher />;
  }
};
```

### Data flow

Basically two way of passing data down with server call. One is parent component make a server request, usually in the `componentDidMount` and `componentWillMount`, and pass down the data using props to the children components. The disadvantage of that is the verbose passing process.

Another way is allow children components to make request themselves, which is the way of GraphQL.

## ES6

### Arrow functions
what the heck is the arrow function? ** Unlike functions, arrows share the same lexical this as their surrounding code.**

### Modules
Language-level support for modules for component definition. Codifies patterns from popular JavaScript module loaders (AMD, CommonJS). Runtime behaviour defined by a host-defined default loader. Implicitly async model – no code executes until requested modules are available and processed.

```js

// lib/math.js
export function sum(x, y) {
  return x + y;
}
export var pi = 3.141593;
// app.js
import * as math from "lib/math";
console.log("2π = " + math.sum(math.pi, math.pi));
// otherApp.js
import {sum, pi} from "lib/math";
console.log("2π = " + sum(pi, pi));
```

Some additional features include `export default` and `export *`:

```js
// lib/mathplusplus.js
export * from "lib/math";
export var e = 2.71828182846;
export default function(x) {
    return Math.exp(x);
}
// app.js
import exp, {pi, e} from "lib/mathplusplus";
console.log("e^π = " + exp(pi));
```

### Deconstructing

```js
let [a, b] = [1, 2];
// a === 1
// b === 2

let { ui, name } = this.props;
// ui === this.props.ui;
// name === this.props.name

let { blogpost: { title, slug } } = this.props;
// title === this.props.blogpost.title;
// slug === this.props.blogpost.slug;
```

### Functional binding

```js
class Link extends Component {

  click() {
    console.log(this.props);
    console.log('Clicked with scope', this);
  }

  render() {
    return <a href='#' onClick={ ::this.click }>Click me!</a>
  }

}
```

Adding the function bind syntax to ::this.click converts down to this.click.bind(this), ensuring that your callbacks in a component are called with this scoped to the component.

### Spread operator

尤其在React Native的redux框架里， 我们不能在reducer里修改state， 只能每次返回一个新的object， 这时候spread syntax特别方便。

```js
import * as postActions from 'actions/posts';
import * as userActions from 'actions/users';

let actions = (dispatch) => {
  return bindActionCreators({ ...postActions, ...userActions}, dispatch);
}
```

In this example we create a new object containing all values from postActions and userActions in one line.

## React interview question

Check more information from [this post](https://www.codementor.io/reactjs/tutorial/5-essential-reactjs-interview-questions).

- Under what circumstances would you choose React over (AngularJS, etc)?
- If React only focuses on a small part of building UI components, can you explain some pitfalls one might encounter when developing a large application?
- If you were rewriting an AngularJS application in React, how much code could you expect to re-use?

### High-Level Component Lifecycle

At the highest level, React components have lifecycle events that fall into three general categories:

- Initialization
- State/Property Updates
- Destruction

Every React component defines these events as a mechanism for managing its properties, state, and rendered output. Some of these events only happen once, others happen more frequently; understanding these three general categories should help you clearly visualize when certain logic needs to be applied.

For example, components will automatically re-render themselves any time their properties or state change. However in some cases a component might not need to update — so preventing the component from re-rendering might improve the performance of our application.
```javascript
class MyComponent extends React.Component {

    // only re-render if the ID has changed!
    shouldComponentUpdate(nextProps, nextState) {
        return nextProps.id === this.props.id;
    }
}
```

### Example interview coding challenge

```js
class MyComponent extends React.Component {
    constructor(props) {
        // set the default internal state
        this.state = {
            clicks: 0
        };
    }

    componentDidMount() {
        this.refs.myComponentDiv.addEventListener(
            ‘click’, 
            this.clickHandler
        );
    }

    componentWillUnmount() {
        this.refs.myComponentDiv.removeEventListener(
            ‘click’, 
            this.clickHandler
        );
    }

    clickHandler() {
        this.setState({
            clicks: this.clicks + 1
        });
    }

    render() {
        let children = this.props.children;

        return (
            <div className=”my-component” ref=”myComponentDiv”>
                <h2>My Component ({this.state.clicks} clicks})</h2>
                <h3>{this.props.headerText}</h3>
                {children}
            </div>
        );
    }
}
```

However, there are two problems with the code above.

```js
// The constructor does not pass its props to the super class. It should include the following line:
constructor(props) {
        super(props);
        // ...
    }
    
// The event listener (when assigned via addEventListener()) is not properly scoped because ES2015 doesn’t provide autobinding. Therefore we might re-assign clickHandler in the constructor to include the correct binding to this:
constructor(props) {
        super(props);
              this.clickHandler = this.clickHandler.bind(this);
        // ...
    }
```

And in order to use this component, we can do this:

```js
<MyComponent headerText=”A list of paragraph tags”>
    <p>First child.</p>
    <p>Any other <span>number</span> of children...</p>
</MyComponent>
```
