#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\E[0M"
WEB_HOST=web.prabha1.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE-"/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>>LOGFILE

VALIDATE(){
    if[ $1 -ne 0 ]
    then
       echo -e "$2....$R FAILED $N"
       exit 1
    else 
       echo -e "$2....$G SUCCESS $N"
    fi 
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROOR:Please run this script with root acess $H"
    exit 1
else
   echo "You are a root user"
fi 

dnf install nginx -y &>>LOGFILE

VALIDATE $? " installig nginix"

systemctl enable nginx
systemctl start nginx

VALIDATE $? "starting nginix"

rm -rf /usr/share/nginx/html/* &>>LOGFILE

VALIDATE $? "removing extras"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>LOGFILE
VALIDATE $? "downloading into temp file"
cd /usr/share/nginx/html &>>LOGFILE
VALIDATE $?"extracting frontend"
unzip /tmp/web.zip &>>LOGFILE
VALIDATE $?"unziping file"

cp web.repo/etc/yum.repos.d/ &>>LOGFILE

systemctl restart nginx 
VALIDATE $?"Restarting nginix"
}