#!/bin/bash

#Global variables

USERNAME_FILENAME="username.file"
LOGS_FOLDER='logs'

echo "Uninstalling the application"

rm $USERNAME_FILENAME

rm -r $LOGS_FOLDER

sleep 2

echo "Application uninstalled succesfully!"