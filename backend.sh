#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
echo "Enter MySQL db password:"
read -s mysql_root_password

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2..$R FAILURE $N"
        exit 1
    else
        echo -e "$2..$G SUCCESS $N"
    fi

}
if [$USERID -ne 0 ]
then
    echo "Please run the command with root user"
else
    echo "You are Super User"
fi

dnf module disable nodejs:18 -y &>>LOGFILE
VALIDATE $? "Disabling nodejs18"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense

if [$? -ne 0 ]
then
    useradd expense &>>$LOGFILE
else
    echo "user id expense is already exists $Y SKIPPING $N"
fi

mkdir -p app/ &>>LOGFILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
cd /app
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Unzip the backend file"
cd /app
npm install &>>$LOGFILE
VALIDATE $? "Installing dependent libraries"

cp /home/ec2-user/test-practice/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Creatign backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon-reload"

systemctl start backend&>>$LOGFILE
VALIDATE $? "start backend"

systemctl enable backend&>>$LOGFILE
VALIDATE $? "enable backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql server client"

mysql -h db.hasamas.site -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Loading DB schema"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "restart backend server"








