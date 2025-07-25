#!/bin/bash
set -e

trap 'failure ${LINENO} "$BASH_COMMAND"' ERR
failure(){
     echo "Failed at $1: $2"
}


USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1,2)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



check_root(){
    if [ $USERID -ne 0 ]
    then
        echo "Please run this script with root access."
        exit 1 # manually exit if error comes.
    else
        echo "You are super user."
    fi
}


VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2... $R FAILURE $N"
        exit 1
   else
       echo -e "$2... $G SUCCESS $N"
   fi
}