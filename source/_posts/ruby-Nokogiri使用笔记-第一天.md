title: ruby Nokogiri使用笔记[第一天]
date: 2015-08-27 22:52:07
tags: [rails]
categories: 技术
---

将wikipedia上面表格中的信息的一个整合， 重点：掌握关于筛选和array manipulation的技巧

<!-- more -->

```` 
require 'nokogiri'
require 'open-uri'

BASE_WIKIPEDIA_URL = "http://en.wikipedia.org"
LIST_URL = "#{BASE_WIKIPEDIA_URL}/wiki/List_of_Nobel_laureates"
page = Nokogiri::HTML(open(LIST_URL))
rows = page.css('div.mw-content-ltr table.wikitable tr')       

rows[1..-2].each do |row|
  hrefs = row.css("td a").map{ |a| 
    a['href'] if a['href'].match("/wiki/")
  }.compact.uniq
  # 对每一个row里面将不同的cell里面的link收集起来，然后filter
  # 同样长度的array在filter之后不符合要求的得到nil然后在compact方法的时候被删掉
  # 然后uniq是删去那些相同的link url

  hrefs.each do |href|
   puts href
  end
end
````