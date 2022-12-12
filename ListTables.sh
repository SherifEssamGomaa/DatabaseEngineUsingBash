#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

tables=`ls -F | grep -v / | grep -v _meta_data`
if [[ "$tables" == "" ]]
then
    echo "Nothing to list"
else
    echo "$tables"
fi 
. TableMainMenu.sh