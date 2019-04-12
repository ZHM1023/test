#!/usr/bin/env bash
#
# author: zhm
# email: 8*******@qq.com
# date : 04/11
# usage: install mysql


printf "Install depending software and init server computer......\n"
rpm -qa | grep mariadb-libs
if [ $? -eq 0 ];then
  rpm -e --nodeps mariadb-libs
fi
yum -y install ncurses ncurses-devel bison libgcrypt perl make cmake wget
  if [ $? -eq 0 ];then 
  yum -y groupinstall "Development Tools"
  fi
printf "OK.../\n"

printf "Download MySQL Server Source code packages....../\n"
wget -O /opt/mysql.tar.gz https://dev.mysql.com/get/Downloads/MySQL-5.7/$1
printf "OK...\n"

printf "Install MySQL Server is ready....../\n"
groupadd mysql
useradd -M -g mysql -s /sbin/nologin mysql
mkdir -p /usr/local/mysqld/{data,mysql,log,tmp}
chown -R mysql:mysql /usr/local/mysql/*
printf "OK.../\n"

printf "Install MySQL Server Begin....../\n"
tar xf /opt/mysql.tar.gz -C /opt/

cmake /opt/$(echo $1 | awk -F"." '{ print "mysql-5."$2"."$3}') -DCMAKE_INSTALL_PREFIX=/usr/local/mysqld/mysql \
-DMYSQL_DATADIR=/usr/local/mysqld/data \
-DWITH_BOOST=/opt/$(echo $1 | awk -F"." '{ print "mysql-5."$2"."$3}')/boost \
-DDEFAULT_CHARSET=utf8
if [ $? -eq 0 ];then
  make -j $(lscpu | awk 'NR==4{ print $2 }')
  if [ $? -eq 0 ];then
    make install 
       if [ $? -eq 0 ];then
	  printf " Install  Successfully.../\n"
	else 
	  printf "Make Install has a error"
	  exit
	fi
  else
  printf " Make has a unknown warning.\n"
  exit
  fi
else
printf " CMake has a unknown warning.\n"
exit
fi

#printf "MySQL Begin init&&start....../\n"
#echo "export PATH=$PATH:/usr/local/mysqld/mysql/bin">>/etc/profile
#source /etc/profile
#echo $?
#chown -R mysql:mysql /usr/local/mysqld/*

#mv /etc/{my.cnf,my.cnf.bak}
#cp /usr/local/mysqld/mysql/mysql-test/include/default_mysqld.cnf /etc/my.cnf

#mysqld --defaults-file=/etc/my.cnf --initialize --user='mysql'
#mysqld_safe --defaults-file=/etc/my.cnf &

#ln -s /usr//local/mysqld/tmp/mysql.sock /tmp/mysql.sock
#ln -s /usr/local/mysqld/mysql/support-files/mysql.server /usr/bin/mysql.server
#cp    /usr/local/mysqld/mysql/support-files/mysql.server /etc/init.d/mysqld
#chkconfig --add mysqld && chkconfig  mysqld on

#PASSWD=$(grep "password" /usr/local/mysqld/log/mysql_error.log | awk -F" " 'NR==1{ print $11 }')
#mysql -uroot -p"$PASSWD" -e"alter user root@localhost identified by 'Zhm..1023'"







