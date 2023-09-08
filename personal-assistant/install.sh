#!/bin/bash

# Global Variables

USERNAME_FILENAME="username.file"
RUN_FILENAME='run.sh'
UNINSTALL_FILENAME="uninstall.sh"
LOGS_FOLDER="LOGS"

# Check if the application is already installed

if [[ -e $USERNAME_FILENAME ]]; then
    echo "Application is already installed"
    exit 0
else
    read -p "Please enter your name: " USERNAME

    # Validations
    if [[ -z $USERNAME ]]; then
        echo "Incorrect username, installer is exiting..."
        sleep 1.5
        exit 0
    fi

    echo "Application is installing"
    sleep 1.5
    echo $USERNAME > $USERNAME_FILENAME

    mkdir $LOGS_FOLDER

    echo "Application installed successfully"
fi

# Give execute rights

if [[ -x $RUN_FILENAME ]]; then
    chmod 744 $RUN_FILENAME
fi

if [[ -x $UNINSTALL_FILENAME ]]; then
    chmod 744 $UNINSTALL_FILENAME
fi

# Ask the user if they want to start the app after installing

read -p "Do you want to start the app? (y/n): " ANSWER

if [[ $ANSWER == "y" ]]; then
    source $RUN_FILENAME
fi
