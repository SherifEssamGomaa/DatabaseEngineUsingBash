#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

createmenu ()
{
  select option; do # in "$@" is the default
    if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#)) ];
    then
      selected_column_name=$option
      selected_column_num=$REPLY
      break;
    else
      echo "Incorrect Input: Select a number 1-$#"
    fi
  done
}
read -p "Enter table name: " table_name
tableExist=`. does_table_exist . $table_name`
while [ "$tableExist" = false ]
do
    echo "ERROR::Table doesn't exist"
    read -p "Enter table name: " table_name
    tableExist=`. does_table_exist . $table_name`
done
read -p "Enter the primary key of the record you want to update a value in it: " primary_key
doesidexist=`. does_id_exist ./"$table_name" $primary_key`
while [ "$doesidexist" = false ]
do
    echo "ERROR::This primary key doesn't exist"
    read -p "Enter the primary key of the record you want to update a value in it":  primary_key
    doesidexist=`. does_id_exist ./"$table_name" $primary_key`
done
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

echo "Select a value to update"
createmenu "${column_names[@]}"
read -p "Enter $selected_column_name new value: " new_value
if [ $selected_column_num = 1 ]
then
    doesidexist=`. does_id_exist ./"$table_name" $new_value`
    isidempty=`. is_id_empty "$new_value"`
    isinteger=`. is_integer "$new_value"`
    while [[ "$doesidexist" = true || "$isidempty" = true || "$isinteger" = false ]]
    do
        if [ "$doesidexist" = true ]
        then
            echo "ERROR::This "$selected_column_name" already exists"
            read -p "Enter $selected_column_name: " new_value
            doesidexist=`. does_id_exist ./"$table_name" $new_value`
            isidempty=`. is_id_empty "$new_value"`
            isinteger=`. is_integer "$new_value"`
        fi
        if [ "$isidempty" = true ]
        then
            echo "ERROR::This is a primary key, it can't be empty"
            read -p "Enter $selected_column_name: " new_value
            doesidexist=`. does_id_exist ./"$table_name" $new_value`
            isidempty=`. is_id_empty "$new_value"`
            isinteger=`. is_integer "$new_value"`
        fi
        if [ "$isinteger" = false ]; then
            echo "ERROR::Enter an integer"
            read -p "Enter $selected_column_name: " new_value
            doesidexist=`. does_id_exist ./"$table_name" $new_value`
            isidempty=`. is_id_empty "$new_value"`
            isinteger=`. is_integer "$new_value"`
        fi
    done
fi
if [[ "${column_data_types[$(("$selected_column_num"-1))]}" = "integer" && "$selected_column_num" -gt 1 ]]; then
        while ! [[ $new_value = "" || $new_value =~ ^[+-]?[0-9]+$ ]]
        do
            echo "ERROR::Enter an integer: "
            read -p "Enter $selected_column_name: " new_value
        done
fi
old_value=$(awk -v idd=$primary_key -v col_num=$selected_column_num '
    BEGIN{FS=" ";} 
    {
        if ($1==idd)
            print $col_num
    }
    END{}
' ./"$table_name")
sed -i "/$primary_key/ s/$old_value/$new_value/" ./"$table_name"
. TableMainMenu.sh