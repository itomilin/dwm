#!/bin/bash

# type of screenshot area or full
TYPE=$1
MAIM_PATH="/home/`id -un 1000`/pictures/maim"
SCROT_NAME="`date +%s`.png"

# if path not exist, then create
if [[ ! -d $MAIM_PATH ]]; then
    mkdir -p $MAIM_PATH
fi

if [[ $TYPE == "area" ]]; then
   maim -o -s -m 10 $MAIM_PATH/$SCROT_NAME
   xclip -selection clipboard -t image/png $MAIM_PATH/$SCROT_NAME
elif [[ $TYPE == "full" ]]; then
   maim -o -m 10 $MAIM_PATH/$SCROT_NAME
   xclip -selection clipboard -t image/png $MAIM_PATH/$SCROT_NAME
else
    echo "Type is not handled"
    exit 1
fi

