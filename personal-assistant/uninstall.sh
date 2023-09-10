#!/bin/bash

#Global variables

USERNAME_FILENAME="username.file"
LOGS_FOLDER='logs'

echo "Uninstalling the application"

rm $USERNAME_FILENAME
# Prompt the user if they want to remove the logs folder

read -p "Do you also want to remove the 'LOGS' folder? (Y/N): " REMOVE_LOGS

if [[ "$REMOVE_LOGS" == "y" || "$REMOVE_LOGS" == "Y" ]]
then
    rm -r $LOGS_FOLDER
    echo "Logs removed"
else
    echo "Logs folder was not removed"
fi


sleep 2

echo "Application uninstalled succesfully!"