# !/bin/bash
 export LC_COLLATE=C
 shopt -s extglob

read -p "Enter new table name: " table_name
tableExist=`. does_table_exist . $table_name`
tableNameValid=`. is_valid $table_name`
while [[ "$tableExist" = true || "$tableNameValid" = false ]]
do
    if [ "$tableExist" = true ] 
    then
        echo "ERROR::Table already exists"
        read -p "Enter new table name: " table_name
        tableExist=`. does_table_exist . $table_name`
        tableNameValid=`. is_valid $table_name`
    fi 
    if [ "$tableNameValid" = false ]
    then
        echo "ERROR::Invalid table name"
        read -p "Enter new table name: " table_name
        tableExist=`. does_table_exist . $table_name`
        tableNameValid=`. is_valid $table_name`
    fi 
done
touch $table_name "$table_name"_meta_data
read -p "Enter number of columns: " num_of_columns
while [[ "$num_of_columns" -le 0 ]]
do
    echo "ERROR::Invalid number of columns"
    read -p "Enter number of columns: " num_of_columns
done
echo "Note: First column will be a primary key"
for (( i=1; i<="$num_of_columns"; i++ ))
do
    read -p "Enter column number $i name: " column_name
    columnExist=`. does_column_exist ./"$table_name"_meta_data $column_name`
    columnNameValid=`. is_valid $column_name`
    while [[ "$columnNameValid" = false || "$columnExist" = true ]]
    do
        if [ "$columnNameValid" = false ]
        then
            echo "ERROR::Invalid column name"
            read -p "Enter column number $i name: " column_name
            columnNameValid=`. is_valid $column_name`
            columnExist=`. does_column_exist ./"$table_name"_meta_data $column_name`
        fi
        if [ "$columnExist" = true ]
        then
            echo "ERROR::Column already exist"
            read -p "Enter column number $i name: " column_name
            columnNameValid=`. is_valid $column_name`
            columnExist=`. does_column_exist ./"$table_name"_meta_data $column_name`
        fi
    done
    if [ "$i" = 1 ]
    then
        column_data_type="integer"
        echo "Note: This is tour primary key and it's an integer"
        echo "$column_name $column_data_type" >> "$table_name"_meta_data
        continue
    fi
    read -p "Enter column number $i datatype (integer or string): " column_data_type
    while [[ "$column_data_type" != "integer" && "$column_data_type" != "string" ]]
    do
        echo "ERROR::Invalid column datatype"
        read -p "Enter column number $i datatype (integer or string) " column_data_type
    done
    echo "$column_name $column_data_type" >> "$table_name"_meta_data
done
echo "Table created successfully"
. TableMainMenu.sh