#!/bin/bash

JDATA=$(curl --silent "https://official-joke-api.appspot.com/random_joke" | jq .)

SETUP=$(echo $JDATA | jq .setup)
PUNCHLINE=$(echo $JDATA | jq .punchline)

echo -e $SETUP
sleep 1
echo -e $PUNCHLINE
