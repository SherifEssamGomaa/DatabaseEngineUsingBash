#!/bin/bash
export LC_COLLATE=C
shopt -s extglob
echo "----------------------------------------"
echo "-       Welcome to our DB Engine       -"
echo "-             Developed by:            -"
echo "-    Sherif Essam $ Mohamed Elgyndy    -"
echo "----------------------------------------"
echo
PS3="Choose a number > "
export PATH=$PATH:$PWD
chmod u+x *.sh
chmod u+x does*
chmod u+x is*
if ! [ -d DB ]
then 
    mkdir DB
fi
. DatabaseMainMenu.sh