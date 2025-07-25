#!/bin/bash

source ./common.sh

check_root

echo "please enter the DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE


systemctl enable mysqld &>>$LOGFILE


systemctl start mysqld &>>$LOGFILE


# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
# we need to give ip address of the db server
mysql -h db.naveen.sbs -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
   
else
 echo "Mysql root pwd is already setup"
 fi

