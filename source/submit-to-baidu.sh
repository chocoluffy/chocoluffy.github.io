#!/bin/bash
echo "http://chocoluffy.com/tech/
http://chocoluffy.com/life/
http://chocoluffy.com/books/
http://chocoluffy.com/weibo/
http://chocoluffy.com/about/" >> baidu_urls.txt
echo Please input your baidu token:
read token
curl -H 'Content-Type:text/plain' --data-binary @baidu_urls.txt "http://data.zz.baidu.com/urls?site=chocoluffy.com&token=$token"