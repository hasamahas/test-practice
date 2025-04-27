#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

echo "Enter MySQL DB password"
read -s mysql_root_password

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 .. $R FAILURE $N"
    else
        echo -e "$2 .. $G SUCCESS $N"
    if
}

if [ $USERID -ne 0 ]
then
    echo "please run this command with root user"
else
    echo "You are super user"
fi

dnf install mysql-server -y &>>LOGFILE
VALIDATE $? "Installing mysql server"

systemctl start mysqld &>>LOGFILE
VALIDATE $? "start mysql server"

systemctl enable mysqld &>>LOGFILE
VALIDATE $? "Enable myslq server"

mysql -h hasamahas.site -uroot -p${mysql_root_password} -e 'show databases;' &>>LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>LOGFILE
    VALIDATE $? "MySQL root password set"
else
    echo "MySQL root password is already set up"
fi

    
