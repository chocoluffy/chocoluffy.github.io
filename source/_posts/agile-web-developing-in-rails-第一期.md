title: Agile web developing in rails 第一期
date: 2015-12-24 11:55:00
tags: [rails]
categories: 技术
---

目的： 将agile rails web application一书里面的精华概括下来， 为之后运用rails开发打基础


<!-- more --> 

## The details you should know about in rails:

- link_to | button_to
在link_to 和 button_to的情况下， 因为浏览器已经知道他们调用的是http的什么方法， 因此我们只需要将他们导流到对应controller
的位置就可以了；rails会根据http的动作调用相应的方法， 然后用一下shortcut path, 也就是 line_item_path;
为了创建一个LineItem obeject， 我们需要product_id和cart_id， cart_id可以在session中得到， product_id则需要用参数传入；
```
<%= button_to 'Add to Cart', line_item_path(product_id: product) % >
```

- Http verb
create(post), new(get)等等

- 写法区别
```
<%= button_to "delete", @cart, :method => :delete % > 
<%= button_to "delete", {:controller => :carts, :action => :destroy, :id => cart.id}, :method => :delete % >
```

- ajax in rails
add Ajax to cart 目的: 在store页面实现将cart的show展示在sidebar里面， 然后添加user interface
注意： 在每一个partial template里面都有一个和template file同名的变量来指代当前变量；

首先， 在发送请求的时候， 将请求改正为ajax请求：
```
<%= button_to "Add to cart", line_items_path(product_id: product), remote: true % >
```
然后， 由于button_to默认http请求动作是post， 在line_items_controller里面找到create这个方法， 然后在response_to里面添加
一个format.js; 在create这个line_items的method处理了ajax的请求后， 就会去渲染一个同名的file： create.js.erb； 由于rails
自动gemfile里面加载了jquery的gem, 所以我们可以直接使用；

重点： format.js 里面也就是create.js.erb里面渲染的js代码是给format.html里面调用使用的， 也就是在重新渲染store/index.html.erb
的时候， 重点不在于index.html.erb， 因为使用ajax的目标之一是只去更新那些改变了的东西， 也就是在sidebar区域的<%= render @cart % >
利用ajax， 我们只希望重新渲染<%= render @cart % >, 其他部分保留；

具体实现的方法： 由于在application.html.erb里面包裹住<%= render @cart % >部分的div是id是cart， 所以我们只需要通过jquery选择
到那个div， 然后修改里面的html使之成为更新后的版本就可以了。
```
$("#cart").html("<%= escape_javascript render(@cart) %>")
```

- Add a member route
To add a member route, just add a member block into the resource block:

```
resources :photos do
  member do
    get 'preview'
  end
end
```
This will recognize /photos/1/preview with GET, and route to the preview action of PhotosController, with the resource 
id value passed in params[:id]. It will also create the preview_photo_url and preview_photo_path helpers.
在我们这个网站里面， 通过增加下面这几行：
```
  resources :line_items do
    member do
      put 'decrement'
    end
  end
```
我们实现的是， 首先能够识别出 /line_items/1/decrement这个路由， 和http里面的put联系起来， 然后去调用line_items controller里面的decrement这个方法
同时也将resource的id传入进来, params[:id], 然后创建 decrement_lin_item_url和 decrement_line_item_path;

**注意： 一直困扰我的， 在点击decrement这个按钮的时候， 会出现internet error 505, unable to load the resources; 然后还看到的是关于line_item_controller里面的各种nil class, 其实这就是一个启示， 表示在那个时候使用的@line_item是没有被赋值的； 因此追根溯源找到的赋值的地方是set_line_item， 我们使用hook, before_action限制了使用这个hook的范围， 因此每一次我们新引进一个method的时候， 我们都需要记得在controller最前面的hook看看有没有限制；**

> 总结一下8.16号犯的一些错误： 
[1]在touch file的时候注意不要放错位置！_line_item.html.erb这个文件的错放导致了很多的问题；
[2]添加了member route之后创建的新方法已开始被hook before_action限制住了， 要记得添加他们的使用范围；
[3]灵通一点， 在decrement.js.erb中， 通过调换其中一些code的顺序也可以达到同样的效果；

- Modify the model
```
rails generate scaffold Order name address:text email pay_type
```
在rails里面， 没有标明type的属性默认： string
```
rails generate migration add_order_to_line_item order:references
```
在已经存在的line_item model里面添加一个column， order_id； 
```
rake db:migrate
```
然后在_cart.html.erb里面增加一个button_to按钮来链接到对应的创建order的操作：
```
<%= button_to "Checkout", new_order_path, method: :get % >
```
```
  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty!"
      return 
      # 提前终止程序， 防止double render， 不仅渲染了notice而且还渲染了下面的@order;
    end
    @order = Order.new
  end
```
**  再补充一遍， new只是得到一个form的页面， 真正的create操作是由create来完成的， 通过http的verb也可以看出来；**

在修改了new的方法之后， 尤其是改变了redirect的方向之后， 需要同时去修改test里面的文件；
```
  test "should redirect to store_url because of empty cart when checkout" do
    get :new
    assert_redirected_to store_url
    assert_equal flash[:notice], "Your cart is empty!"
  end

  test "should get new" do
    item = LineItem.new
    item.build_cart
    item.product = products(:one)
    item.save!
    session[:cart_id] = item.cart.id
    get :new
    assert_response :success
  end
```





































