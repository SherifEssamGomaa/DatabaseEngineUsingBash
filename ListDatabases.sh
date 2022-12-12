#!/bin/bash
export LC_COLLATE=C
shopt -s extglob

databases=`ls -F ./DB/ | grep /`
if [[ "$databases" == "" ]]
then
    echo "No databases to list"
else
    echo $databases
fi
. DatabaseMainMenu.sh