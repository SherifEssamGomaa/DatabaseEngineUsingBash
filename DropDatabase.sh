#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

read -p "Enter database name: " database_name
databaseExist=`. does_database_exist ./DB $database_name`
if [ "$databaseExist" = true ]
then
    rm -r ./DB/$database_name
    echo "$database_name droped successfully"
    . DatabaseMainMenu.sh
else
    echo "ERROR::Database doesn't exist"
    . DatabaseMainMenu.sh
fi