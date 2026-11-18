#!/bin/bash

echo "Enter your ID[Teudat_Zehut] number:"
read -r id

echo "Enter your Full Bar-Ilan Email Address:"
read -r mail

echo "Trying to download bomb file..."

if wget -t 3 --content-disposition \
    "http://127.0.0.1:15213/?username=$USER&usermail=$mail&submit=Submit"
then
    echo "File downloaded Successfully:"
    ls -lh bomb*.tar
else
    echo "File download failed :("
fi

echo "Have a nice day =)"