#!/bin/bash
export LC_COLLATE=C
shopt -s extglob
read -p "Enter new database name: " data_base_name

databaseNameValid=`. is_valid $data_base_name`
databaseExist=`. does_database_exist ./DB $data_base_name`
while [[ $databaseExist = true || "$databaseNameValid" = false ]]
do
    if [ $databaseExist = true ]
    then
        echo "ERROR::Database alredy exists"
        read -p "Enter new database name: " data_base_name
        databaseNameValid=`. is_valid $data_base_name`
        databaseExist=`. does_database_exist ./DB $data_base_name`
    fi
    if [ "$databaseNameValid" = false ] 
    then
         echo "ERROR::Invalid database name"
        read -p "Enter new database name: " data_base_name
        databaseNameValid=`. is_valid $data_base_name`
        databaseExist=`. does_database_exist ./DB $data_base_name`
    fi
done
mkdir ./"DB/$data_base_name" 
echo "Database created successfulyy"
. DatabaseMainMenu.sh