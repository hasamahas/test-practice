#!/bin/bash

COURSE="Devops in current script"

echo "Before callig other script Course: $COURSE"
echo "Process instance id of current script: $$"

#./19-others.sh firt way of calling shell script 

source ./19-others.sh  # 2nd way of calling shell script

echo "After calling other script Course: $COURSE"