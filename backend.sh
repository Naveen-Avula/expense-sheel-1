#!/bin/bash

source ./common.sh

check_root

echo "please enter the DB password:"
read -s mysql_root_password

dnf module disable nodejs -y &>>$LOGFILE


dnf module enable nodejs:20 -y &>>$LOGFILE


dnf install nodejs -y &>>$LOGFILE


id expense  &>>$LOGFILE
if [ $? -ne 0 ]
then useradd expense &>>$LOGFILE

else
    echo -e "Expense user already created...$Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGFILE


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE


cd /app
rm -rf /app/* # -----------IMPortant to remove old files
unzip /tmp/backend.zip


npm install


cp /home/ec2-user/expenses-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl start backend &>>$LOGFILE

systemctl enable backend &>>$LOGFILE

dnf install mysql -y &>>$LOGFILE

mysql -h db.naveen.sbs -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

systemctl restart backend &>>$LOGFILE
