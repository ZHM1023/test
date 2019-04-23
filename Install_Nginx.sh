#!/usr/bin/env bash
#
# author:zhm
# email:980583705@qq.com
# data:2019/04/23


#init system
systemctl stop firewalld && systemctl disable firewalld 
setenforce 0
sed -ri s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

#install nginx
if [ ! -e /usr/bin/wget ];then 
yum -y install wget
fi
#wget http://nginx.org/download/nginx-1.14.2.tar.gz

yum -y groupinstall "Development Tools"
yum -y install pcre pcre-devel openssl openssl-devel zlib zlib-devel

groupadd -g 996 nginx
useradd -u 998 -g 996 -s /sbin/nologin -M nginx 


tar -xf nginx-1.14.2.tar.gz -C /usr/local/

mv /usr/local/{nginx-1.14.2,nginx}

cd /usr/local/nginx 
./configure --group=nginx --user=nginx --prefix=/usr/local/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --with-pcre 


if [ $? -eq 0 ];then
  make && make install 
  if [ $? -eq 0 ];then 
    printf "install OK!\n"
  else
    printf "sth wrong!\n"
    exit
  fi 
else 
   exit
   printf "sth wrong!\n"
fi
 
nginx -v 

nginx 

