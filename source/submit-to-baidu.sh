#!/bin/bash

# input token
echo Please input your baidu token:
read token

# copy baidu_urls.txt to baidu_amp_urls.txt and append '/amp' to all links.
sed -i.bak '!/[^[:blank:]]/s/$/\/amp\//' baidu_urls.txt > baidu_amp_urls.txt

# append more info link to baidu_urls.txt.
echo "\nhttp://chocoluffy.com/tech/\n\
http://chocoluffy.com/life/\n\
http://chocoluffy.com/books/\n\
http://chocoluffy.com/weibo/\n\
http://chocoluffy.com/about/" >> baidu_urls.txt

curl -H 'Content-Type:text/plain' --data-binary @baidu_urls.txt "http://data.zz.baidu.com/urls?site=chocoluffy.com&token=$token"
# curl -H 'Content-Type:text/plain' --data-binary @baidu_amp_urls.txt "http://data.zz.baidu.com/urls?site=chocoluffy.com&token=$token&type=amp"