#!/bin/bash

WDATA=$(curl --silent "https://api.open-meteo.com/v1/forecast?latitude=41.33&longitude=19.81&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin" | jq .daily)

TDATA=($(echo $WDATA | jq -r .time[] | tr -d '[]," '))
TMINTEMP=($(echo $WDATA | jq -r .temperature_2m_min[] | tr -d '[]," '))
TMAXTEMP=($(echo $WDATA | jq -r .temperature_2m_max[] | tr -d '[]," '))

COUNTER=1
for i in "${!TDATA[@]}"
do
        echo "Date: ${TDATA[$i]}        MinTemp: ${TMINTEMP[$i]}°C              MaxTemp: ${TMAXTEMP[$i]}°C"
        ((COUNTER++))
done
