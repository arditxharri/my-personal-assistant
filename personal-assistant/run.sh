#!/bin/bash

USERNAME_FILENAME="username.file"
MAIN_MENU_EXIT_CODE=0
SONG_MENU_EXIT_CODE=0
IS_NUMBER_EXPR='^[0-9]+$'
LYRICS_FOLDER_PATH='resources/lyrics'
WEATHER_SCRIPT_PATH='resources/weather/weather.sh'
ACTIVITY_SCRIPT_PATH='resources/activities/activity.sh'
JOKES_SCRIPT_PATH='resources/jokes/jokes.sh'
LOGS_PATH='logs'

#check if app installed
USERNAME=$(<$USERNAME_FILENAME)

if [ -z $USERNAME ]
then
	echo "The app is not installed. Exiting..."
	sleep 1.5
	exit 0
fi

#greet user
clear
echo "Greetings $USERNAME!"

#functions

function log_action() {

        local DAILY_FILE_NAME=$(date +%F)
        local DAILY_FILE_NAME=$(date +%F).log
        local FULL_LOG_PATH=$LOGS_PATH/$DAILY_FILE_NAME
        local LOG_LINE=$1

        #check if daily file exists
        if ! [ -f $FULL_LOG_PATH ]
        then
                touch $FULL_LOG_PATH
        fi

        #log action
        if ! [ -z "$LOG_LINE" ]
        then
                echo "$(date +'%F %T') User $USERNAME -> $LOG_LINE" >> $FULL_LOG_PATH
        fi
}

function display_menu() {
	
	declare -a menu_items=('Show me the weather for next week!' 'Tell me a joke!' 'Show me the date!' 'Show me song lyrics!' 'Tell me what activity should I do Today?' 'Search for words in song' 'Show today''s logs' )
	
	local COUNTER=1
	for ((i=0; i<${#menu_items[@]}; i++))
	do
		echo "($COUNTER) - ${menu_items[$i]}"
		((COUNTER++))
	done

	((MAIN_MENU_EXIT_CODE=COUNTER))

	echo "($COUNTER) - Exit App"	
}

function display_song_list () {
	
	local SONGS=($(ls $LYRICS_FOLDER_PATH))
	local COUNTER=1
	
	echo "------------------------------------------"
	for ((i=0; i<${#SONGS[@]}; i++ ))
        do
		echo "($COUNTER) - ${SONGS[$i]}"
		((COUNTER++))
        done
	((SONG_MENU_EXIT_CODE=COUNTER))
	echo "($COUNTER) - Go back"
	echo "------------------------------------------"

}

function display_song_list_menu() {
	
	local SONG_FILES=($(ls $LYRICS_FOLDER_PATH))

	while true
	do
		display_song_list

		read -p "Choose a song to display its lyrics or choose 'Go back' to return to the main menu: " SONG_OPTION

		case "$SONG_OPTION" in
		"$SONG_MENU_EXIT_CODE")
			echo "Exiting Songs Menu"
			sleep 0.8
			break;;
		*)
			if [[ $SONG_OPTION =~ $IS_NUMBER_EXPR && $SONG_OPTION -gt 0 && $SONG_OPTION -le ${#SONG_FILES[@]} ]]
			then
				((SONG_OPTION--))
				echo ""				
				cat $LYRICS_FOLDER_PATH/${SONG_FILES[$SONG_OPTION]}
				echo ""
				read -n 1 -r -s -p "Press any key to display song selection menu..." key
				echo ""
			else
				echo "Please input a correct value!"
			fi
		esac
	done	
}

function check_and_execute_scripts() {
	local SCRIPT_PATH=$1

	if [ -z $SCRIPT_PATH ]
	then
		echo "Parameter not provided!"
	elif ! [ -f $SCRIPT_PATH ]
	then
		echo "$SCRIPT_PATH does not exist"
	elif ! [ -x $SCRIPT_PATH ]
	then
		echo "You do not have the permission to execute $SCRIPT_PATH"
	else
		source $SCRIPT_PATH
	fi
}

function search_words_in_lyrics () {
	#grep -wn 'down' resources/lyrics/*.txt
	local GREP_RESULT=''

	read -p "Please type the words you want to search: " WORDS

	sleep 0.8

	log_action "Searched lyrics for: $WORDS"
	GREP_RESULT=$(grep -wniF "$WORDS" $LYRICS_FOLDER_PATH/*.txt)
       
	if [ -z "$GREP_RESULT" ]
	then
		echo "No results for: '$WORDS'"
	else
		echo "$GREP_RESULT"
	fi
}

function show_logs() {
	local DAILY_FILE_NAME=$(date +%F)
        local DAILY_FILE_NAME=$(date +%F).log
        local FULL_LOG_PATH=$LOGS_PATH/$DAILY_FILE_NAME

	cat $FULL_LOG_PATH
}

#App Logic here
log_action "***************************************************"
log_action "Starting application"
while true
do	
	echo ""
	echo "******************************"
	echo "How may I help you today?"
	echo "******************************"
	
	display_menu

	read -p "Choose an option: " OPTION
	echo "******************************"
	echo ""

	case "$OPTION" in
	"1")
		sleep 0.8
		log_action "Asked the weather"	
		check_and_execute_scripts $WEATHER_SCRIPT_PATH
		;;
	"2")
		sleep 0.8
		log_action "Asked for a joke"
		check_and_execute_scripts $JOKES_SCRIPT_PATH
		;;
	"3")
		sleep 0.8
		log_action "Asked for the date"
		echo "Today's date is $(date)"
		;;
	"4")
		sleep 0.8
		log_action "Asked to display song lyrics"
		display_song_list_menu
		;;
	"5")
		sleep 0.8
		log_action "Asked for an activity"
		check_and_execute_scripts $ACTIVITY_SCRIPT_PATH
		;;
	"6")
		sleep 0.8
		log_action "Asked to search words in song lyrics"
		search_words_in_lyrics
		;;
	"7")
		sleep 0.8
		show_logs
		;;
	"$MAIN_MENU_EXIT_CODE")
		echo "Exiting the app... Goodbye $USERNAME!"
		sleep 1
		break;;
	*)
		sleep 0.8
		echo "Please input a correct value!"
	esac
done

log_action "Exiting application"
log_action "***************************************************"

display_menu