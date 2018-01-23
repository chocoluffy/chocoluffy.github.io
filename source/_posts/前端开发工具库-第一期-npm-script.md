title: '前端开发工具库[第一期]-npm script'
date: 2016-05-15 17:48:45
tags: [javascript, nodejs]
categories: 技术
---

在自动构建工具grunt\webpack等红噪一时的背景下，为什么我想用npm script而不是grunt和gulp等其他工具?

<!-- more -->

## 前言

为什么我们需要自动构建工具？

在前端开发的时候，会遇到很多实际产品开发之外上的需求，比如开发者希望做到“所写即所得”，可以一边在编辑器里面修改和开发代码，浏览器可以同步更新而不需要我们手动去refresh页面； 比如我们希望可以压缩最后的成品代码， 图片资源的大小，让每次浏览器下载所需要的js代码的时间可以更短，或者考虑CDN； 比如我们希望我们写的scss可以适配任何类型的浏览器等等。

很多功能曾经是要开发者手动引入script文件的，但鉴于npm上活跃的开发者将很多需求的module开发并发布出来， 我们可以利用npm这个包管理器来配置使用这些方便的module，在能够达到同样功能的工具里面比如bower, grunt, gulp，我认为对于一个轻量的小项目， 个人项目来说, npm script是最方便的， 最容易上手的。**没有最好的工具， 只有最合适的使用场景。**

而今天的主题：在配置工具grunt\webpack等红噪一时的背景下，为什么我想用npm script而不是grunt和gulp等其他工具?

**因为simplicity matters。**没有必要在需要用的时候才去找那些数量有限的grunt, gulp plugins，而直接将node modules拿来用。对于个人开发和维护的小项目， 有没有必要花时间去研究Gruntfile.js怎么去配置， 或者说， 在配置上花的时间相对短期集中开发的时间来说值不值？不是说反对使用grunt, gulp和webpack等工具， 而是我们没有必要拿大炮去打蚊子， 我们想要agile development。 也正是simplicy， 所以才有RoR, meteor等全栈框架的出现来挑战java等较为臃肿的开发流程不是么？

下图是截止至今年1月为止的各平台的插件数量，仍在不断地增加中。

![npm script](http://ac-TC2Vc5Tu.clouddn.com/f247d4b81bd3044a.png)

## 什么是npm script

其实npm script就是希望执行的command的alias， 类似与command line里面的make， 通过提前设置希望执行的命令， 我们可以通过`npm run <alias>`来执行我们预先设置的命令。 还有一些特别方便的commands比如：
- `npm home request`， 可以直接跳转到那个module的介绍页面；
- `npm install request --save`可以将我们使用的modules以“^”形式保存在package.json文件里面， 这意味着下一次用同一个package.json安装依赖模块时， 没有经过major version jump的模块可以下载到本地项目目录； 
- `npm install --production`可以安装生产环境的模块， 同`NODE_ENV=production npm install`

## 如何config你的npm script

而目前npm上有很多很棒的module可以直接处理项目， 下面列出来的是我平时自己经常使用的module: 

比如: browserfy将文件的各种文件和浏览器同步; postcss和autofixer可以将css文件添加适配各种浏览器的前缀同时进行压缩; js-lint用来检查js文件的各种格式细节; uglify用来压缩js文件的大小; imagemin用来压缩各种图片文件的大小， 在各种大型网站中， 图片的大小占据了大部分。

### node－sass

下面是一些具体使用的例子：比如我们想将sass compile成css。

```sh
npm install --save-dev node-sass
```

将`node-sass`这个module装在developing环境之后，可以直接`node-sass --output-style compressed -o dist/css src/scss`来将”src/scss“这个文件夹下面的sass文件compile出来并保存在”dist/css“文件夹下面； 或者一个更便捷的做法，是使用npm script：

```js
"scripts": {
  "scss": "node-sass --output-style compressed -o dist/css src/scss"
}
```

然后在console里run `npm run scss`就可以执行这个相同命令了。和makefile的原理和使用习惯可以类比， 只不过使用场景和平台不同。

### autoprefixer

同理对上文提到的autoprefixer这个module， `npm install --save-dev postcss-cli autoprefixer`来安装， 然后配置script：

```js
"scripts": {
  ...
  "autoprefixer": "postcss -u autoprefixer -r dist/css/*"
}
```

那么`npm run autoprefixer`这个效果就相当于`postcss -u autoprefixer --autoprefixer.browsers '> 5%, ie 9' -r dist/css/*`。

### eslint

类似地还有eslint这个对js文件进行syntax testing的常用module：`npm install --save-dev eslint`或者使用shortcut：`npm i -D eslint`, 然后配置package.json的script部分：

```js
"scripts": {
  ...
  "lint": "eslint src/js"
}
```

## 项目源代码示例

一个实战项目的源代码使用在这里和大家分享：

考虑到开发和生产环境的不同，还需要配置不同的环境，这个项目在开发上有浏览器同步更新，语法检查，压缩源文件， 监听端口， s3同步备份的自动化优势， 还引入了前端的jade框架代替html， stylus框架代替css，mocha的testing框架和karma驱动。

```js
{
  "name": "npm-scripts-example",
  "version": "1.0.0",
  "description": "An example of how to use npm scripts",
  "main": "index.js",
  "license": "MIT",
  "devDependencies": {
    "browserify": "^6.3.2",
    "hashmark": "^2.0.0",
    "http-server": "^0.7.3",
    "jade": "^1.7.0",
    "jshint": "^2.5.10",
    "karma": "^0.12.28",
    "karma-browserify": "^1.0.0",
    "karma-cli": "^0.0.4",
    "karma-mocha": "^0.1.10",
    "karma-phantomjs-launcher": "^0.1.4",
    "live-reload": "^0.2.0",
    "minifyify": "^6.0.0",
    "mocha": "^2.0.1",
    "nodemon": "^1.2.1",
    "opener": "^1.4.0",
    "parallelshell": "^1.0.0",
    "rimraf": "^2.2.8",
    "s3-cli": "^0.11.1",
    "stylus": "^0.49.3"
  },
  "scripts": {
    "clean": "rimraf dist/*",

    "prebuild": "npm run clean -s",
    "build": "npm run build:scripts -s && npm run build:styles -s && npm run build:markup -s",
    "build:scripts": "browserify -d assets/scripts/main.js -p [minifyify --compressPath . --map main.js.map --output dist/main.js.map] | hashmark -n dist/main.js -s -l 8 -m assets.json 'dist/{name}{hash}{ext}'",
    "build:styles": "stylus assets/styles/main.styl -m -o dist/ && hashmark -s -l 8 -m assets.json dist/main.css 'dist/{name}{hash}{ext}'",
    "build:markup": "jade assets/markup/index.jade --obj assets.json -o dist",

    "test": "karma start --singleRun",

    "watch": "parallelshell \"npm run watch:test -s\" \"npm run watch:build -s\"",
    "watch:test": "karma start",
    "watch:build": "nodemon -q -w assets/ --ext '.' --exec 'npm run build'",

    "open:prod": "opener http://example.com",
    "open:stage": "opener http://staging.example.internal",
    "open:dev": "opener http://localhost:9090",

    "deploy:prod": "s3-cli sync ./dist/ s3://example-com/prod-site/",
    "deploy:stage": "s3-cli sync ./dist/ s3://example-com/stage-site/",

    "serve": "http-server -p 9090 dist/",
    "live-reload": "live-reload --port 9091 dist/",

    "dev": "npm run open:dev -s && parallelshell \"npm run live-reload -s\" \"npm run serve -s\" \"npm run watch -s\""
  }
}
```

很多时候就是因为准备的工具效率高， 开发者也因此得以集中精力于产品逻辑， 在更短的时间内开发出更好更稳定的产品。

## 后记小结

npm script不是没有缺点的，就像我一再强调的，没有最好的工具， 只有最合适的使用场景， 在个人小项目适合的npm script，在大项目， 动辄几十万的前端项目的构建和测试下， npm script会显得特别臃肿和难以维护。 而目前大热的grunt\gulp\webpack也迎来了他们的舞台。下一期，集中介绍grunt和webpack，公司里使用的也是grunt，为什么它会在众多工具中脱颖而出。

## 参考链接

- [用npm搭配脚本执行](https://www.zybuluo.com/yangfch3/note/249328) npm 不仅可以用于模块管理，还可以用于执行脚本。对于多个任务的操作很方便！
- [Mimicking npm script in Node.js](https://www.nczonline.net/blog/2016/03/mimicking-npm-script-in-node-js/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+nczonline+%28NCZOnline+-+The+Official+Web+Site+of+Nicholas+C.+Zakas%29) The underlying mechanism of using npm script is that npm modifies the PATH environment variable so that it affects the lookup of executables. Run `npm install --save-dev eslint`, then do `npm run lint`, it works because npm script is actually running `node_modules/.bin/eslint`.
- [Gulp is awesome, but do we really need it?](http://gon.to/2015/02/26/gulp-is-awesome-but-do-we-really-need-it/)
- [How to Use npm as a Build Tool](http://blog.keithcirkel.co.uk/how-to-use-npm-as-a-build-tool/)

