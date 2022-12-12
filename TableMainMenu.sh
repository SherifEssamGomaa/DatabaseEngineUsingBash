#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update Table" "Back"
do 
case $choice in 
"Create Table")
    . CreateTable.sh
;;
"List Tables")
    . ListTables.sh
;;
"Drop Table")
    . DropTaple.sh
;;
"Insert into Table")
    . InsertIntoTable.sh
;;
"Select from Table")
    . SelectFromTable.sh
;;
"Delete from Table")
    . DeleteFromTable.sh
;;
"Update Table")
    . UpdateTable.sh
;;
"Back")
    cd ../..
    . DatabaseMainMenu.sh
;;
*)
    echo "ERROR::Invalid number"
;;   
esac
done