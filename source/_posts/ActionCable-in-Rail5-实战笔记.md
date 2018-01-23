title: ActionCable in Rail5 实战笔记
date: 2015-12-26 12:42:33
tags: [rails]
categories: 技术
---

rails5 ActionCable in chatroom, 为之后开发狼人多人游戏做准备

<!-- more -->

- 整个流程
After `rails new chat` and `bundle install`, we add some related in Gemfile, so now it will look like this:

```
source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'actioncable', github: 'rails/actioncable'

gem 'sqlite3'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'puma'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug'
  gem 'spring'
  gem 'web-console', '~> 2.0'
end
	
```

[1] in routes.rb, we set the root page to be 
```
root ‘sessions#new’
```
which means that it will first find the SessionsController’s new method and implement it. We know in rails that when it runs a controller method, it will also render the corresponding views html.erb in view folder. Thus the `views/sessions/new.html.erb` will be first rendered. 

Further observing in routes.rb:
```
Rails.application.routes.draw do
  resources :messages, only: [:index, :create]
  resources :sessions, only: [:new, :create]
  root 'sessions#new'
end
```
we find the use of `resources`, which means we treat those objects as RESTFUL as we could, those objects in their controllers will have all seven methods like new, create, update, destroy and so on which corresponds to the Http Verbs like post, get and so on.

## Then, we look at the new.html.erb

```
<%= form_for :session, url: sessions_path do |f| %>
	<%= f.label :username, 'Enter a name' %><br/>
	<%= f.text_field :username %> <br>
	<%= f.submit 'Start chatting' %>
<% end %>
```
where `:session` is the name for this form, when in use in SessionsController, we obtain the information in this form by 
```
cookies.signed[:username] = params[:session][:username]
```
And `url: sessions_path` is for directing the action to SessionsController#create.

## In MessagesController.rb
we use index to render the view
```
Signed in as @<%= cookies.signed[:username] %>.
<br><br>

<div id="messages"></div>
<br><br>

<%= form_for :message, url: messages_path, remote: true, id: messages-form do |f| %>
	<%= f.label :body, 'Enter a message:' %> <br>
	<%= f.text_field :body %> <br>
	<%= f.submit 'Send message' %>
<% end %>
```

where the cookies are carrying the parameters we need in another controller, while the empty `div` will eventually be filled with previous content. As for the form, it will pretty similar as the SessionsController#new.
* here we use `remote: true`, which is calling with Ajax. In usual case, we will need to specify the partial js file we want to implement in MessagesContrller#create method. * But, here we just want it to reload again without refreshing the page.

## ActionCable

ActionCable uses Redis for publishihng and subscribing to the messages, so we need to configure Redis in config/redis/cable.yml. You will need Redis installed and running for ActionCable to work.


## Redis
reds is a key-value store, often referred to as a NoSQL database. Key features are that: [1] the data can be retrieved by key later in use. [2] the key-value will be stored permanently.

```
SET server:name “fido”
GET server:name
DEL server:name
INCR count
```
Compared with 
```
x = GET count
x = x + 1
SET count x
```
we choose to use INCR because it is a atomic operation which will work as expected if multiple users want to access this value.
```
EXPIRE server:name 120 //after 120s this value will vanish
TTL server:name // obtain after how long it will vanish
```

### List operation ###
`RPUSH, LPUSH, LLEN, LRANGE, LPOP, RPOP`

### Set operation ###
`SADD, SREM, SISMEMBER, SMEMBERS, SUNION`
where `SMEMBERS` returns a list of all members of this set.

### Sorted Set ###
`ZADD, ZRANGE`

### Hashes ###
`HSET, HGETALL, HMSET, HGET, HINCRBY, HDEL` like

```
HMSET user:1001 name "Mary Jones" password "hidden" email "mjones@example.com"
HGETALL user:1001
```

## Adding our MessagesChannel

```
# app/channels/messages_channel.rb
class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'messages'
  end
end
```
whenever a client subscribes to MessageChannel, the `#subscribed` method will be called, which starts streaming anything you broadcast to the “messages” stream.

## Future learning
- [Rails 5's ActionCable and Websockets Introduction](https://gorails.com/episodes/rails-5-actioncable-websockets)
- [Action Cable Examples](https://github.com/rails/actioncable-examples)


> 后记： 欢迎加入我的私人公众号， 和你分享我思考的观点和文章：
![公众号二维码](http://ww2.sinaimg.cn/large/c5ee78b5gw1ezbljkk2apj20by0byq3q.jpg)






















