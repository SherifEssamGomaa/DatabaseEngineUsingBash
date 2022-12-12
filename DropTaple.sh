#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

read -p "Enter table name: " table_name 
haveTables=`ls -F | grep -v / | grep -v _meta_data`
table_exist=`. does_table_exist . $table_name` 
if [[ "$haveTables" == "" ]]
then
    echo "Nothing to Delete"
    . TableMainMenu.sh
elif [ "$table_exist" = true ]
then
    rm $table_name "$table_name"_meta_data
    echo "Table droped successfully"
    . TableMainMenu.sh
else 
    echo "ERROR:table doesn't exist"
    . TableMainMenu.sh
fi