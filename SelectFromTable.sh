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
      echo "ERROR::Invalid input"
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
select choice in "Select all" "Select a column" "Select a row"
do
case $choice in
"Select all")
    cat $table_name
    . TableMainMenu.sh
;;
"Select a column")
    column_names=( $(
        awk '
        BEGIN{FS=" ";}
        {
            print $1
        }END{}' ./"$table_name"_meta_data) ) 
    createmenu "${column_names[@]}" 
    awk -v column_num="$selected_column_num" '
        BEGIN{FS=" ";}
        {
            print $column_num
        }END{}' ./"$table_name"
    . TableMainMenu.sh
;;
"Select a row")
    column_names=( $(
        awk '
        BEGIN{FS=" ";}
        {
            print $1
        }END{}' ./"$table_name"_meta_data) )
    echo "Choose a column to setect a row by its value"
    createmenu "${column_names[@]}"
    read -p "Enter "$selected_column_name" value to select: " column_value
    doesColumnValueExist=`. does_column_value_exist "$table_name" "$selected_column_num" "$column_value"`
    while [ "$doesColumnValueExist" = false ]
    do
        echo "ERROR::Column value doesn't exist"
        read -p "Enter "$selected_column_name" value to select its row: " column_value
        doesColumnValueExist=`. does_column_value_exist "$table_name" "$selected_column_num" "$column_value"`
    done
    awk -v column_num="$selected_column_num" -v colum_val="$column_value" '
        BEGIN{FS=" ";}
        {
            if ($column_num==colum_val)
                print $0
        }END{}' ./"$table_name"
    . TableMainMenu.sh
;;
*)
    echo "ERROR::Invaild input"
;;    
esac
done

