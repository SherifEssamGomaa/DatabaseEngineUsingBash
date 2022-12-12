# !/bin/bash
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
select choice in "Delete all table data" "Delete a row"
do
case $choice in
"Delete all table data")
    echo "" > "$table_name"
    echo "Table data deleted succssfully"
    . TableMainMenu.sh
;;
"Delete a row")
    column_names=( $(
        awk '
        BEGIN{FS=" ";}
        {
            print $1
        }END{}' ./"$table_name"_meta_data) ) 
    echo "Choose a column do delete a row by its value"
    createmenu "${column_names[@]}" 
    read -p "Enter "$selected_column_name" value to delete its row: " column_value
    doesColumnValueExist=`. does_column_value_exist "$table_name" "$selected_column_num" "$column_value"`
    while [ "$doesColumnValueExist" = false ]
    do
        echo "ERROR::Column value doesn't exist"
        read -p "enter "$selected_column_name" value to delete its row: " column_value
        doesColumnValueExist=`. does_column_value_exist "$table_name" "$selected_column_num" "$column_value"`
    done
    line=$(
    awk -v column_num="$selected_column_num" -v column_val="$column_value" '
        BEGIN{FS=" ";line=""} 
        {
            if ($column_num==column_val)
                line=NR
        }
        END{print line}
    ' $table_name
    )
    sed -in "$line"d "$table_name"
    echo "Row deleted succssfully"
    . TableMainMenu.sh
;;
*)
    echo "ERROR::Invaild input"
;;      
esac
done