#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

read -p "Enter database name: " data_base_name
databaseExist=`. does_database_exist ./DB $data_base_name`
if [ "$databaseExist" = true ]
then
    cd ./DB/$data_base_name
    . TableMainMenu.sh
else
    echo "REEOR::Database doesn't exist"
    . DatabaseMainMenu.sh
fi