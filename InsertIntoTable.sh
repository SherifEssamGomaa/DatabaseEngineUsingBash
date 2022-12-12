#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

read -p "Enter table name: " table_name
tableExist=`. does_table_exist . $table_name`
while [ "$tableExist" = false ]
do
    echo "ERROR::Table doesn't exist"
    read -p "Enter table name: " table_name
    tableExist=`. does_table_exist . $table_name`
done
num_of_columns=`wc -l "$table_name"_meta_data | cut -d" " -f1`
column_names=( $(
awk '
    BEGIN{FS=" ";}
    {
        print $1
    }END{}' ./"$table_name"_meta_data) )
column_data_types=( $(
awk '
    BEGIN{FS=" ";}
    {
        print $2
    }END{}' ./"$table_name"_meta_data) )
entered_values=()
num=0
while [ "$num" -lt "$num_of_columns" ]
do
    read -p "Enter ${column_names[$num]}: " entered_value
    if [[ "$num" = 0 ]] 
    then
        doesidexist=`. does_id_exist ./"$table_name" $entered_value`
        isidempty=`. is_id_empty "$entered_value"`
        isinteger=`. is_integer "$entered_value"`
        while [[ "$doesidexist" = true || "$isidempty" = true || "$isinteger" = false ]]
        do
            if [ "$doesidexist" = true ] 
            then
                echo "ERROR::This "${column_names[$num]}" already exists"
                read -p "Enter ${column_names[$num]}: " entered_value
                doesidexist=`. does_id_exist ./"$table_name" $entered_value`
                isidempty=`. is_id_empty "$entered_value"`
                isinteger=`. is_integer "$entered_value"`
            fi
            if [ "$isidempty" = true ]
            then
                echo "ERROR::This is a primary key, it can't be empty"
                read -p "Enter ${column_names[$num]}: " entered_value
                doesidexist=`. does_id_exist ./"$table_name" $entered_value`
                isidempty=`. is_id_empty "$entered_value"`
                isinteger=`. is_integer "$entered_value"`
            fi
            if [ "$isinteger" = false ]
            then
                echo "Enter an integer for the primary key"
                read -p "Enter ${column_names[$num]}: " entered_value
                doesidexist=`. does_id_exist ./"$table_name" $entered_value`
                isidempty=`. is_id_empty "$entered_value"`
                isinteger=`. is_integer "$entered_value"`
            fi
        done
    fi
    if [[ "${column_data_types[$num]}" = "integer" && $num -gt 0 ]] 
    then
        while ! [[ $entered_value = "" || $entered_value =~ ^[+-]?[0-9]+$ ]]
        do
            echo "ERROR::Enter an integer"
            read -p "Enter ${column_names[$num]}: " entered_value
        done
    fi
    entered_values+=($entered_value)
    let num=$num+1
done
echo "${entered_values[@]}" >> "$table_name"
echo "Row inserted successfully"
. TableMainMenu.sh