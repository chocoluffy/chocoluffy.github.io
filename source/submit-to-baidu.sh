#!/bin/bash
echo "\nhttp://chocoluffy.com/tech/\n\
http://chocoluffy.com/life/\n\
http://chocoluffy.com/books/\n\
http://chocoluffy.com/weibo/\n\
http://chocoluffy.com/about/" >> baidu_urls.txt
echo Please input your baidu token:
read token
curl -H 'Content-Type:text/plain' --data-binary @baidu_urls.txt "http://data.zz.baidu.com/urls?site=chocoluffy.com&token=$token"