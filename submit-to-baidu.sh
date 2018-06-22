#!/bin/bash
echo Please input your baidu token:
read token
curl -H 'Content-Type:text/plain' --data-binary @baidu_urls.txt "http://data.zz.baidu.com/urls?site=chocoluffy.com&token=$token"