#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

select choice in "Create Database" "List Databases" "Drop Database" "Connect to Database" "Exit"
do 
case $choice in 
"Create Database")
#creat database by calling file .sh 
    . CreateDatabase.sh
;;
"List Databases")
#list database by calling file .sh 
    . ListDatabases.sh
;;
"Drop Database")
#drop database by calling file .sh 
    . DropDatabase.sh
;;
"Connect to Database")
#connect database by calling file .sh 
    . ConnectToDatabase.sh
;;
"Exit")
#exit the program
    echo "GOOD BYE"
    exit
;;
*)
    echo "ERROR::Invalid choice"
;;    
esac
done